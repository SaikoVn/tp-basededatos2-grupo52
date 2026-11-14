/*
08 - Pruebas simples para la demostracion

Ejecutar despues de 01 a 07 y antes de modificar los turnos desde la aplicacion.
Las escrituras de prueba se muestran en pantalla y luego se revierten.
Asi el script se puede ejecutar mas de una vez sin dejar filas de prueba.

Para probar la aplicacion:
1. En Turnos, registrar la atencion del turno "Demo 07: pendiente para atencion".
   Se deben guardar el diagnostico, el pago y el estado atendido juntos.
2. Usar "Demo 07: pendiente para cambios" para probar reprogramacion,
   cancelacion y eliminacion.
3. En Pagos solo se consultan y filtran los pagos registrados.
*/
USE [Veterinaria];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @idDuenio1 INT;
DECLARE @idMascota1 INT;
DECLARE @idMascota2 INT;
DECLARE @idProfesional1 INT;
DECLARE @idProfesional2 INT;
DECLARE @idTurnoAtendido INT;
DECLARE @idTurnoPendiente INT;
DECLARE @hoy DATE = CONVERT(DATE, GETDATE());
DECLARE @desde DATETIME;
DECLARE @hastaExclusivo DATETIME;

SELECT @idDuenio1 = id_duenio
FROM dbo.Duenios
WHERE dni = '990000001';

SELECT @idMascota1 = id_mascota
FROM dbo.Mascotas
WHERE nombre = 'Milo' AND id_duenio = @idDuenio1;

SELECT @idMascota2 = id_mascota
FROM dbo.Mascotas
WHERE nombre = 'Nube'
  AND id_duenio = (SELECT id_duenio FROM dbo.Duenios WHERE dni = '990000002');

SELECT @idProfesional1 = id_profesional
FROM dbo.Profesionales
WHERE matricula = 'VET-DEMO-01';

SELECT @idProfesional2 = id_profesional
FROM dbo.Profesionales
WHERE matricula = 'VET-DEMO-02';

SELECT @idTurnoAtendido = id_turno
FROM dbo.Turnos
WHERE motivo = 'Demo 07: turno atendido';

SELECT @idTurnoPendiente = id_turno
FROM dbo.Turnos
WHERE motivo = 'Demo 07: pendiente para atencion'
  AND estado = 'pendiente';

IF @idDuenio1 IS NULL OR @idMascota1 IS NULL OR @idMascota2 IS NULL
   OR @idProfesional1 IS NULL OR @idProfesional2 IS NULL
   OR @idTurnoAtendido IS NULL OR @idTurnoPendiente IS NULL
    THROW 50801, 'Faltan datos iniciales. Ejecute primero el script 07 en una base limpia.', 1;

PRINT 'PRUEBA 1: funcion y cuatro vistas';

-- Funcion de usuario, llamada directamente.
SELECT
    @idMascota1 AS id_mascota,
    dbo.fn_CantidadConsultasMascota(@idMascota1) AS consultas_atendidas;

-- Las cuatro vistas.
SELECT *
FROM dbo.vw_AgendaTurnosActivos
WHERE id_duenio = @idDuenio1
ORDER BY fecha_hora_inicio;

SELECT *
FROM dbo.vw_HistorialClinicoPorMascota
WHERE id_mascota = @idMascota1;

SELECT *
FROM dbo.vw_ResumenFacturacionPorProfesional
WHERE id_profesional IN (@idProfesional1, @idProfesional2)
ORDER BY id_profesional;

SELECT *
FROM dbo.vw_FrecuenciaConsultasMascotas
WHERE id_mascota IN (@idMascota1, @idMascota2)
ORDER BY id_mascota;

PRINT 'PRUEBA 2: procedimiento de reporte con parametros';

SET @desde = DATEADD(DAY, -2, CONVERT(DATETIME, @hoy));
SET @hastaExclusivo = DATEADD(DAY, 4, CONVERT(DATETIME, @hoy));

EXEC dbo.sp_ReporteTurnosProfesional
    @id_profesional = @idProfesional1,
    @desde = @desde,
    @hasta_exclusivo = @hastaExclusivo;

-- Caso de validacion: el procedimiento debe rechazar desde >= hasta.
BEGIN TRY
    EXEC dbo.sp_ReporteTurnosProfesional
        @id_profesional = @idProfesional1,
        @desde = @hastaExclusivo,
        @hasta_exclusivo = @desde;

    ;THROW 50802, 'El reporte acepto un rango de fechas invalido.', 1;
END TRY
BEGIN CATCH
    IF ERROR_NUMBER() = 50001
        PRINT 'OK: el procedimiento rechazo el rango de fechas invalido.';
    ELSE
        THROW;
END CATCH;

PRINT 'PRUEBA 3: procedimiento de accion y registro de atencion';

DECLARE @idTurnoAccion INT;
DECLARE @inicioAccion DATETIME =
    DATEADD(HOUR, 15, CONVERT(DATETIME, DATEADD(DAY, 5, @hoy)));

BEGIN TRY
    BEGIN TRANSACTION;

    -- Se crea un turno temporal para probar el procedimiento.
    INSERT dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, estado, motivo)
    VALUES
        (@idMascota1, @idProfesional1, @inicioAccion, DATEADD(MINUTE, 30, @inicioAccion),
         'pendiente', '08: prueba temporal del procedimiento');
    SET @idTurnoAccion = CONVERT(INT, SCOPE_IDENTITY());

    -- El procedimiento registra el pago y cambia el estado a atendido.
    EXEC dbo.sp_RegistrarPagoYAtenderTurno
        @id_turno = @idTurnoAccion,
        @nro_comprobante = 'DEMO-08-001',
        @monto = 18000.00,
        @metodo_pago = 'transferencia';

    -- La aplicacion inserta la historia clinica dentro de la misma transaccion.
    INSERT dbo.HistoriasClinicas (id_turno, diagnostico, tratamiento, observaciones)
    VALUES (@idTurnoAccion, 'Control de prueba', 'Sin tratamiento adicional', 'Fila temporal');

    SELECT
        t.id_turno,
        t.estado,
        pg.id_pago,
        pg.nro_comprobante,
        pg.monto,
        h.id_historia,
        h.diagnostico
    FROM dbo.Turnos AS t
    INNER JOIN dbo.Pagos AS pg ON pg.id_turno = t.id_turno
    INNER JOIN dbo.HistoriasClinicas AS h ON h.id_turno = t.id_turno
    WHERE t.id_turno = @idTurnoAccion;

    -- Revertimos la prueba para que no queden datos temporales.
    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT 'PRUEBA 4: triggers de alta, reprogramacion, cancelacion y baja';

DECLARE @idTurnoTrigger INT;
DECLARE @inicioTrigger DATETIME =
    DATEADD(HOUR, 15, CONVERT(DATETIME, DATEADD(DAY, 10, @hoy)));

BEGIN TRY
    BEGIN TRANSACTION;

    -- INSERT: crea el turno y el trigger registra el alta.
    INSERT dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, estado, motivo)
    VALUES
        (@idMascota2, @idProfesional2, @inicioTrigger, DATEADD(MINUTE, 30, @inicioTrigger),
         'pendiente', '08: prueba temporal de triggers');
    SET @idTurnoTrigger = CONVERT(INT, SCOPE_IDENTITY());

    -- UPDATE: cambia inicio y fin; el trigger registra la reprogramacion.
    UPDATE dbo.Turnos
    SET fecha_hora_inicio = DATEADD(DAY, 1, fecha_hora_inicio),
        fecha_hora_fin = DATEADD(DAY, 1, fecha_hora_fin)
    WHERE id_turno = @idTurnoTrigger;

    -- UPDATE: la cancelacion tambien queda auditada.
    UPDATE dbo.Turnos
    SET estado = 'cancelado'
    WHERE id_turno = @idTurnoTrigger;

    -- DELETE: se elimina el turno; la auditoria conserva su identificador.
    DELETE dbo.Turnos
    WHERE id_turno = @idTurnoTrigger;

    -- Estas filas muestran los cuatro eventos antes de revertir la prueba.
    SELECT
        id_turno,
        tipo_evento,
        fecha_hora_inicio_anterior,
        fecha_hora_inicio_nueva,
        fecha_hora_fin_anterior,
        fecha_hora_fin_nueva,
        motivo_evento,
        fecha_evento
    FROM dbo.AuditoriaTurnos
    WHERE id_turno = @idTurnoTrigger
    ORDER BY id_auditoria;

    ROLLBACK TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;

PRINT 'Fin de las pruebas. Las filas temporales se revirtieron; los datos de 07 se conservan.';
GO
