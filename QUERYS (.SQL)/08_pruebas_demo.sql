-- 0DEMOSTRACION PARA EL VIDEO
-- Ejecutar despues de 07, solo una vez

USE Veterinaria;
GO

-- 1. MOSTRAR LAS CUATRO VISTAS
PRINT '1. Consultamos las vistas';
SELECT * FROM dbo.vw_AgendaTurnosActivos ORDER BY fecha_hora_inicio;
SELECT * FROM dbo.vw_HistorialClinicoPorMascota ORDER BY fecha_registro;
SELECT * FROM dbo.vw_ResumenFacturacionPorProfesional ORDER BY id_profesional;
SELECT * FROM dbo.vw_FrecuenciaConsultasMascotas ORDER BY total_consultas_atendidas DESC;
GO

-- 2. EJECUTAR EL PROCEDIMIENTO QUE MUESTRA TURNOS DE UN PROFESIONAL
PRINT '2. Reporte de turnos de Eva';
DECLARE @id_profesional INT;
DECLARE @desde DATETIME, @hasta DATETIME;
SELECT @id_profesional = id_profesional
FROM dbo.Profesionales WHERE matricula = 'MAT-TPI-01';
SET @desde = DATEADD(DAY, 7, CAST(GETDATE() AS DATE));
SET @hasta = DATEADD(DAY, 1, @desde);
EXEC dbo.sp_ReporteTurnosProfesional @id_profesional, @desde, @hasta;
GO

-- 3. EJECUTAR EL PROCEDIMIENTO QUE REGISTRA UN PAGO
PRINT '3. Registramos un pago y comprobamos el estado';
DECLARE @turno_pago INT;
SELECT @turno_pago = id_turno FROM dbo.Turnos WHERE motivo = 'TPI: Pagar';

SELECT * FROM dbo.Turnos WHERE id_turno = @turno_pago; -- ANTES
EXEC dbo.sp_RegistrarPagoYAtenderTurno
    @id_turno = @turno_pago,
    @nro_comprobante = 'TPI-COMP-0001',
    @monto = 12500.00,
    @metodo_pago = 'tarjeta';
SELECT * FROM dbo.Pagos WHERE id_turno = @turno_pago;  -- DESPUES
SELECT * FROM dbo.Turnos WHERE id_turno = @turno_pago; -- Ahora: atendido
GO

-- 4. PROBAR EL TRIGGER UPDATE: REPROGRAMACION Y CANCELACION
PRINT '4. Reprogramamos y cancelamos turnos';
SELECT * FROM dbo.Turnos WHERE motivo IN ('TPI: Reprogramar', 'TPI: Cancelar');

UPDATE dbo.Turnos
SET fecha_hora_inicio = DATEADD(HOUR, 2, fecha_hora_inicio),
    fecha_hora_fin = DATEADD(HOUR, 2, fecha_hora_fin)
WHERE motivo = 'TPI: Reprogramar';

UPDATE dbo.Turnos SET estado = 'cancelado'
WHERE motivo = 'TPI: Cancelar';
SELECT * FROM dbo.Turnos WHERE motivo IN ('TPI: Reprogramar', 'TPI: Cancelar');
GO

-- 5. PROBAR EL TRIGGER DELETE: BAJA FISICA
PRINT '5. Eliminamos un turno sin pago ni historia';
SELECT * FROM dbo.Turnos WHERE motivo = 'TPI: Eliminar';
DELETE FROM dbo.Turnos WHERE motivo = 'TPI: Eliminar';
SELECT * FROM dbo.Turnos WHERE motivo = 'TPI: Eliminar'; -- Sin filas
GO

-- 6. MOSTRAR QUE EL PROCEDIMIENTO RECHAZA CASOS INVALIDOS
-- TRY/CATCH nos deja mostrar el error sin detener toda la demostracion.
PRINT '6. Pagos rechazados';
BEGIN TRY
    DECLARE @cancelado INT;
    SELECT @cancelado = id_turno FROM dbo.Turnos WHERE motivo = 'TPI: Cancelar';
    EXEC dbo.sp_RegistrarPagoYAtenderTurno @cancelado, 'TPI-ERROR-1', 100, 'efectivo';
END TRY
BEGIN CATCH
    PRINT 'Correcto: no permite pagar un turno cancelado.';
    PRINT ERROR_MESSAGE();
END CATCH;

BEGIN TRY
    DECLARE @inactivo INT;
    SELECT @inactivo = id_turno FROM dbo.Turnos WHERE motivo = 'TPI: Mascota inactiva';
    EXEC dbo.sp_RegistrarPagoYAtenderTurno @inactivo, 'TPI-ERROR-2', 100, 'efectivo';
END TRY
BEGIN CATCH
    PRINT 'Correcto: no permite pagar el turno de una mascota inactiva.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- 7. PROBAR QUE NO SE PERMITEN TURNOS SUPERPUESTOS
PRINT '7. Turno superpuesto (error esperado)';
BEGIN TRY
    INSERT INTO dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, motivo)
    SELECT id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin,
           'TPI: Turno superpuesto'
    FROM dbo.Turnos WHERE motivo = 'TPI: Pagar';
END TRY
BEGIN CATCH
    PRINT 'Correcto: el trigger impide turnos superpuestos.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- 8. PROBAR QUE NO SE ASIGNAN TURNOS A PROFESIONALES INACTIVOS
PRINT '8. Profesional inactivo (error esperado)';
UPDATE dbo.Profesionales SET activo = 0 WHERE matricula = 'MAT-TPI-02';
DECLARE @id_luna INT, @id_pablo INT, @fecha_prueba DATETIME;
SELECT @id_luna = id_mascota FROM dbo.Mascotas WHERE nombre = 'Luna';
SELECT @id_pablo = id_profesional FROM dbo.Profesionales WHERE matricula = 'MAT-TPI-02';
SET @fecha_prueba = DATEADD(DAY, 8, GETDATE());
BEGIN TRY
    INSERT INTO dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, motivo)
    VALUES (@id_luna, @id_pablo, @fecha_prueba,
            DATEADD(MINUTE, 30, @fecha_prueba), 'TPI: Profesional inactivo');
END TRY
BEGIN CATCH
    PRINT 'Correcto: el trigger impide asignar un profesional inactivo.';
    PRINT ERROR_MESSAGE();
END CATCH;
UPDATE dbo.Profesionales SET activo = 1 WHERE matricula = 'MAT-TPI-02';
GO

-- 9. COMPROBAR LOS REGISTROS DE AUDITORIA (LOS CUATRO TIPOS)
PRINT '9. Consultamos la auditoria completa';
SELECT * FROM dbo.AuditoriaTurnos ORDER BY id_auditoria;
GO

-- 10. VER FACTURACION DESPUES DE REGISTRAR EL PAGO
PRINT '10. Facturacion actualizada';
SELECT * FROM dbo.vw_ResumenFacturacionPorProfesional ORDER BY id_profesional;
GO
