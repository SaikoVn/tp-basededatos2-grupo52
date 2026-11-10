-- DATOS DE EJEMPLO
-- Ejecutar (una vez) luego de los otros 6
USE Veterinaria;
GO

-- 1. Especialidades
INSERT INTO dbo.Especialidades (nombre)
VALUES ('Clinica general'), ('Dermatologia');

-- 2. Duenios
INSERT INTO dbo.Duenios (dni, nombre, apellido, telefono, email, direccion)
VALUES
('90000001', 'Ana', 'Ejemplo', '1100010001', 'ana@example.test', 'Calle 1'),
('90000002', 'Luis', 'Prueba', '1100020002', 'luis@example.test', 'Calle 2');

-- 3. Buscamos los ID creados automaticamente (IDENTITY).
DECLARE @ana INT, @luis INT;
DECLARE @general INT, @dermatologia INT;

SELECT @ana = id_duenio FROM dbo.Duenios WHERE dni = '90000001';
SELECT @luis = id_duenio FROM dbo.Duenios WHERE dni = '90000002';
SELECT @general = id_especialidad FROM dbo.Especialidades WHERE nombre = 'Clinica general';
SELECT @dermatologia = id_especialidad FROM dbo.Especialidades WHERE nombre = 'Dermatologia';

-- 4. Mascotas (activo se completa automaticamente con DEFAULT 1).
INSERT INTO dbo.Mascotas (id_duenio, nombre, especie, raza, fecha_nacimiento, sexo)
VALUES
(@ana, 'Milo', 'Perro', 'Mestizo', '2021-04-15', 'M'),
(@luis, 'Luna', 'Gato', 'Europeo', '2020-08-01', 'F'),
(@luis, 'Nube', 'Perro', 'Caniche', '2019-06-23', 'F');

-- 5. Profesionales (tambien se crean activos por defecto).
INSERT INTO dbo.Profesionales
    (id_especialidad, matricula, nombre, apellido, telefono, email)
VALUES
(@general, 'MAT-TPI-01', 'Eva', 'Garcia', '1120000001', 'eva@example.test'),
(@dermatologia, 'MAT-TPI-02', 'Pablo', 'Lopez', '1120000002', 'pablo@example.test');

-- 6. Guardamos los ID de mascotas y profesionales.
DECLARE @milo INT, @luna INT, @nube INT;
DECLARE @eva INT, @pablo INT;

SELECT @milo = id_mascota FROM dbo.Mascotas WHERE id_duenio = @ana AND nombre = 'Milo';
SELECT @luna = id_mascota FROM dbo.Mascotas WHERE id_duenio = @luis AND nombre = 'Luna';
SELECT @nube = id_mascota FROM dbo.Mascotas WHERE id_duenio = @luis AND nombre = 'Nube';
SELECT @eva = id_profesional FROM dbo.Profesionales WHERE matricula = 'MAT-TPI-01';
SELECT @pablo = id_profesional FROM dbo.Profesionales WHERE matricula = 'MAT-TPI-02';

-- 7. Para que las fechas no queden viejas, los turnos seran dentro de 7 dias.
-- DATEADD(HOUR, 9, @dia) = ese dia a las 09:00.
DECLARE @dia DATETIME;
SET @dia = DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

INSERT INTO dbo.Turnos
    (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, estado, motivo)
VALUES
(@milo, @eva,   DATEADD(HOUR, 9, @dia),  DATEADD(MINUTE, 30, DATEADD(HOUR, 9, @dia)),  'pendiente', 'TPI: Pagar'),
(@milo, @eva,   DATEADD(HOUR, 10, @dia), DATEADD(MINUTE, 30, DATEADD(HOUR, 10, @dia)), 'pendiente', 'TPI: Reprogramar'),
(@luna, @pablo, DATEADD(HOUR, 9, @dia),  DATEADD(MINUTE, 30, DATEADD(HOUR, 9, @dia)),  'pendiente', 'TPI: Cancelar'),
(@luna, @eva,   DATEADD(HOUR, 14, @dia), DATEADD(MINUTE, 30, DATEADD(HOUR, 14, @dia)), 'pendiente', 'TPI: Eliminar'),
(@nube, @pablo, DATEADD(HOUR, 11, @dia), DATEADD(MINUTE, 30, DATEADD(HOUR, 11, @dia)), 'atendido',  'TPI: Historia clinica'),
(@nube, @pablo, DATEADD(HOUR, 16, @dia), DATEADD(MINUTE, 30, DATEADD(HOUR, 16, @dia)), 'pendiente', 'TPI: Mascota inactiva');

-- 8. Creamos una historia clinica para Nube.
DECLARE @turno_historia INT;
SELECT @turno_historia = id_turno
FROM dbo.Turnos WHERE motivo = 'TPI: Historia clinica';

INSERT INTO dbo.HistoriasClinicas (id_turno, diagnostico, tratamiento, observaciones)
VALUES (@turno_historia, 'Control clinico', 'Seguimiento general',
        'Ejemplo de historia de una mascota inactiva');

-- 9. Baja LOGICA de Nube. Su historia clinica se conserva.
UPDATE dbo.Mascotas SET activo = 0 WHERE id_mascota = @nube;
GO
