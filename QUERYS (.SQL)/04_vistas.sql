-- VISTAS: consultas ya preparadas para mostrar informacion
-- Las vistas son SELECT guardados con un nombre.

USE Veterinaria;
GO

-- VISTA 1: agenda de turnos de mascotas activas
CREATE VIEW dbo.vw_AgendaTurnosActivos
AS
SELECT
    t.id_turno, t.fecha_hora_inicio, t.fecha_hora_fin, t.estado, t.motivo,
    m.id_mascota, m.nombre AS mascota, m.especie,
    d.id_duenio, d.nombre AS nombre_duenio, d.apellido AS apellido_duenio,
    p.id_profesional, p.nombre AS nombre_profesional,
    p.apellido AS apellido_profesional,
    e.nombre AS especialidad
FROM dbo.Turnos t
INNER JOIN dbo.Mascotas m ON t.id_mascota = m.id_mascota
INNER JOIN dbo.Duenios d ON m.id_duenio = d.id_duenio
INNER JOIN dbo.Profesionales p ON t.id_profesional = p.id_profesional
INNER JOIN dbo.Especialidades e ON p.id_especialidad = e.id_especialidad
WHERE m.activo = 1;
GO

-- VISTA 2: historias clinicas, incluso de mascotas dadas de baja
CREATE VIEW dbo.vw_HistorialClinicoPorMascota
AS
SELECT
    m.id_mascota, m.nombre AS mascota, m.especie, m.activo AS mascota_activa,
    d.nombre AS nombre_duenio, d.apellido AS apellido_duenio,
    h.id_historia, h.fecha_registro, h.diagnostico,
    h.tratamiento, h.observaciones,
    t.id_turno, t.fecha_hora_inicio,
    p.id_profesional, p.nombre AS nombre_profesional,
    p.apellido AS apellido_profesional,
    dbo.fn_CantidadConsultasMascota(m.id_mascota) AS total_consultas_atendidas
FROM dbo.HistoriasClinicas h
INNER JOIN dbo.Turnos t ON h.id_turno = t.id_turno
INNER JOIN dbo.Mascotas m ON t.id_mascota = m.id_mascota
INNER JOIN dbo.Duenios d ON m.id_duenio = d.id_duenio
INNER JOIN dbo.Profesionales p ON t.id_profesional = p.id_profesional;

GO

-- VISTA 3: dinero cobrado por cada profesional
CREATE VIEW dbo.vw_ResumenFacturacionPorProfesional
AS
SELECT
    p.id_profesional, p.matricula,
    p.nombre AS nombre_profesional, p.apellido AS apellido_profesional,
    COUNT(pg.id_pago) AS cantidad_pagos,
    ISNULL(SUM(pg.monto), 0) AS total_facturado
FROM dbo.Profesionales p
LEFT JOIN dbo.Turnos t ON p.id_profesional = t.id_profesional
LEFT JOIN dbo.Pagos pg ON t.id_turno = pg.id_turno
GROUP BY p.id_profesional, p.matricula, p.nombre, p.apellido;
-- ISNULL muestra 0 cuando un profesional no tiene pagos.
GO

-- VISTA 4: cantidad de consultas atendidas por mascota
CREATE VIEW dbo.vw_FrecuenciaConsultasMascotas
AS
SELECT
    m.id_mascota, m.nombre AS mascota, m.especie, m.activo,
    d.dni AS dni_duenio,
    dbo.fn_CantidadConsultasMascota(m.id_mascota) AS total_consultas_atendidas
FROM dbo.Mascotas m
INNER JOIN dbo.Duenios d ON m.id_duenio = d.id_duenio;
GO
