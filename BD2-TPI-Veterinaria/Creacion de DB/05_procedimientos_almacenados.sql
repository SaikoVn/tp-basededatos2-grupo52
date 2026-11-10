-- PROCEDIMIENTOS ALMACENADOS

USE Veterinaria;
GO

-- PROCEDIMIENTO 1: informe de turnos de un profesional entre dos fechas
CREATE PROCEDURE dbo.sp_ReporteTurnosProfesional
    @id_profesional INT,
    @desde DATETIME,
    @hasta_exclusivo DATETIME
AS
BEGIN
    -- La fecha de inicio debe ser anterior a la fecha final.
    IF @desde >= @hasta_exclusivo
        THROW 50001, 'La fecha desde debe ser anterior a la fecha hasta.', 1;

    SELECT
        t.id_turno, t.fecha_hora_inicio, t.fecha_hora_fin,
        t.estado, t.motivo,
        m.id_mascota, m.nombre AS mascota,
        d.nombre AS nombre_duenio, d.apellido AS apellido_duenio,
        p.id_profesional, p.nombre AS nombre_profesional,
        p.apellido AS apellido_profesional
    FROM dbo.Turnos t
    INNER JOIN dbo.Mascotas m ON t.id_mascota = m.id_mascota
    INNER JOIN dbo.Duenios d ON m.id_duenio = d.id_duenio
    INNER JOIN dbo.Profesionales p ON t.id_profesional = p.id_profesional
    WHERE t.id_profesional = @id_profesional
      AND t.fecha_hora_inicio >= @desde
      AND t.fecha_hora_inicio < @hasta_exclusivo
    ORDER BY t.fecha_hora_inicio;
END;
GO

-- PROCEDIMIENTO 2: registra un pago y marca el turno como atendido
CREATE PROCEDURE dbo.sp_RegistrarPagoYAtenderTurno
    @id_turno INT,
    @nro_comprobante VARCHAR(20),
    @monto DECIMAL(10,2),
    @metodo_pago VARCHAR(30)
AS
BEGIN
    -- Usamos una transaccion porque el pago y el cambio de estado
    -- deben suceder juntos. Si falla uno, se deshacen ambos.
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM dbo.Turnos WHERE id_turno = @id_turno)
            THROW 50002, 'El turno indicado no existe.', 1;

        IF EXISTS (
            SELECT 1
            FROM dbo.Turnos t
            INNER JOIN dbo.Mascotas m ON t.id_mascota = m.id_mascota
            WHERE t.id_turno = @id_turno AND m.activo = 0
        )
            THROW 50003, 'No se permiten pagos de mascotas inactivas.', 1;

        IF EXISTS (
            SELECT 1 FROM dbo.Turnos
            WHERE id_turno = @id_turno AND estado = 'cancelado'
        )
            THROW 50004, 'No se puede pagar un turno cancelado.', 1;

        IF EXISTS (SELECT 1 FROM dbo.Pagos WHERE id_turno = @id_turno)
            THROW 50005, 'Este turno ya tiene un pago.', 1;

        -- El CHECK valida monto y metodo. el UNIQUE valida comprobante y turno
        INSERT INTO dbo.Pagos (id_turno, nro_comprobante, monto, metodo_pago)
        VALUES (@id_turno, @nro_comprobante, @monto, @metodo_pago);

        UPDATE dbo.Turnos
        SET estado = 'atendido'
        WHERE id_turno = @id_turno;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si hubo un error, deshacemos los cambios.
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH;
END;
GO
