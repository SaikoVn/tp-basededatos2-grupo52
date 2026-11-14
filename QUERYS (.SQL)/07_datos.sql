/*
07 - Datos de ejemplo para la veterinaria creado por CHATGPT a modo de prueba para la base de datos
*/
USE [Veterinaria];
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Evita duplicar el lote si el script ya fue ejecutado.
    IF EXISTS (
        SELECT 1
        FROM dbo.Duenios
        WHERE dni IN ('990000001', '990000002')
    )
    OR EXISTS (
        SELECT 1
        FROM dbo.Profesionales
        WHERE matricula IN ('VET-DEMO-01', 'VET-DEMO-02')
    )
        THROW 51007, 'Los datos de ejemplo ya existen. Ejecute el script 07 una sola vez.', 1;

    -- Especialidades
    IF NOT EXISTS (SELECT 1 FROM dbo.Especialidades WHERE nombre = 'Clinica general')
        INSERT dbo.Especialidades (nombre) VALUES ('Clinica general');

    IF NOT EXISTS (SELECT 1 FROM dbo.Especialidades WHERE nombre = 'Dermatologia')
        INSERT dbo.Especialidades (nombre) VALUES ('Dermatologia');

    DECLARE @idEspecialidad1 INT;
    DECLARE @idEspecialidad2 INT;
    DECLARE @idDuenio1 INT;
    DECLARE @idDuenio2 INT;
    DECLARE @idMascota1 INT;
    DECLARE @idMascota2 INT;
    DECLARE @idProfesional1 INT;
    DECLARE @idProfesional2 INT;
    DECLARE @idTurnoAtendido INT;
    DECLARE @hoy DATE = CONVERT(DATE, GETDATE());
    DECLARE @inicioAtendido DATETIME;
    DECLARE @inicioPendiente1 DATETIME;
    DECLARE @inicioPendiente2 DATETIME;

    SELECT @idEspecialidad1 = id_especialidad
    FROM dbo.Especialidades
    WHERE nombre = 'Clinica general';

    SELECT @idEspecialidad2 = id_especialidad
    FROM dbo.Especialidades
    WHERE nombre = 'Dermatologia';

    -- Duenios
    INSERT dbo.Duenios (dni, nombre, apellido, telefono, email, direccion)
    VALUES ('990000001', 'Ana', 'Lopez', '1100000001', 'ana@example.test', 'Calle 1');
    SET @idDuenio1 = CONVERT(INT, SCOPE_IDENTITY());

    INSERT dbo.Duenios (dni, nombre, apellido, telefono, email, direccion)
    VALUES ('990000002', 'Luis', 'Perez', '1100000002', 'luis@example.test', 'Calle 2');
    SET @idDuenio2 = CONVERT(INT, SCOPE_IDENTITY());

    -- Mascotas
    INSERT dbo.Mascotas (id_duenio, nombre, especie, raza, fecha_nacimiento, sexo)
    VALUES (@idDuenio1, 'Milo', 'Perro', 'Mestizo', '2022-05-10', 'M');
    SET @idMascota1 = CONVERT(INT, SCOPE_IDENTITY());

    INSERT dbo.Mascotas (id_duenio, nombre, especie, raza, fecha_nacimiento, sexo)
    VALUES (@idDuenio2, 'Nube', 'Gato', 'Comun europeo', '2021-09-15', 'F');
    SET @idMascota2 = CONVERT(INT, SCOPE_IDENTITY());

    -- Profesionales
    INSERT dbo.Profesionales
        (id_especialidad, matricula, nombre, apellido, telefono, email, activo)
    VALUES
        (@idEspecialidad1, 'VET-DEMO-01', 'Eva', 'Suarez', '1100001001', 'eva@example.test', 1);
    SET @idProfesional1 = CONVERT(INT, SCOPE_IDENTITY());

    INSERT dbo.Profesionales
        (id_especialidad, matricula, nombre, apellido, telefono, email, activo)
    VALUES
        (@idEspecialidad2, 'VET-DEMO-02', 'Juan', 'Diaz', '1100001002', 'juan@example.test', 1);
    SET @idProfesional2 = CONVERT(INT, SCOPE_IDENTITY());

    -- Un turno atendido de ayer y dos turnos pendientes para los proximos dias.
    SET @inicioAtendido = DATEADD(HOUR, 10, CONVERT(DATETIME, DATEADD(DAY, -1, @hoy)));
    SET @inicioPendiente1 = DATEADD(HOUR, 9, CONVERT(DATETIME, DATEADD(DAY, 2, @hoy)));
    SET @inicioPendiente2 = DATEADD(HOUR, 10, CONVERT(DATETIME, DATEADD(DAY, 2, @hoy)));

    INSERT dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, estado, motivo)
    VALUES
        (@idMascota1, @idProfesional1, @inicioAtendido, DATEADD(MINUTE, 30, @inicioAtendido),
         'atendido', 'Demo 07: turno atendido');
    SET @idTurnoAtendido = CONVERT(INT, SCOPE_IDENTITY());

    INSERT dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, estado, motivo)
    VALUES
        (@idMascota1, @idProfesional1, @inicioPendiente1, DATEADD(MINUTE, 30, @inicioPendiente1),
         'pendiente', 'Demo 07: pendiente para atencion');

    INSERT dbo.Turnos
        (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, estado, motivo)
    VALUES
        (@idMascota2, @idProfesional2, @inicioPendiente2, DATEADD(MINUTE, 30, @inicioPendiente2),
         'pendiente', 'Demo 07: pendiente para cambios');

    -- El turno atendido tiene tanto pago como historia clinica.
    INSERT dbo.Pagos (id_turno, nro_comprobante, monto, metodo_pago, fecha_pago)
    VALUES (@idTurnoAtendido, 'DEMO-07-001', 15000.00, 'transferencia',
            DATEADD(MINUTE, 40, @inicioAtendido));

    INSERT dbo.HistoriasClinicas (id_turno, diagnostico, tratamiento, observaciones, fecha_registro)
    VALUES (@idTurnoAtendido, 'Control general sin hallazgos', 'Continuar controles anuales',
            'Datos de ejemplo', DATEADD(MINUTE, 35, @inicioAtendido));

    COMMIT TRANSACTION;

    -- Los turnos insertados tambien generan eventos de alta en AuditoriaTurnos.
    SELECT
        d.dni,
        m.id_mascota,
        m.nombre AS mascota,
        m.especie
    FROM dbo.Mascotas AS m
    INNER JOIN dbo.Duenios AS d ON d.id_duenio = m.id_duenio
    WHERE d.dni IN ('990000001', '990000002')
    ORDER BY d.dni;

    SELECT
        id_profesional,
        matricula,
        nombre + ' ' + apellido AS profesional
    FROM dbo.Profesionales
    WHERE matricula IN ('VET-DEMO-01', 'VET-DEMO-02')
    ORDER BY matricula;

    SELECT
        t.id_turno,
        t.motivo,
        t.fecha_hora_inicio,
        t.fecha_hora_fin,
        t.estado
    FROM dbo.Turnos AS t
    WHERE t.motivo LIKE 'Demo 07:%'
    ORDER BY t.fecha_hora_inicio;

    SELECT
        t.id_turno,
        pg.id_pago,
        h.id_historia
    FROM dbo.Turnos AS t
    LEFT JOIN dbo.Pagos AS pg ON pg.id_turno = t.id_turno
    LEFT JOIN dbo.HistoriasClinicas AS h ON h.id_turno = t.id_turno
    WHERE t.id_turno = @idTurnoAtendido;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
