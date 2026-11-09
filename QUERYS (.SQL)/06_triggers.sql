-- TRIGGERS: se ejecutan automaticamente al modificar Turnos
-- INSERTED: filas nuevas. DELETED: filas anteriores o borradas.

USE Veterinaria;
GO

-- TRIGGER 1: al crear turnos
CREATE TRIGGER dbo.trg_Turnos_AfterInsert
ON dbo.Turnos
AFTER INSERT
AS
BEGIN
    -- Regla 1: el profesional debe estar activo.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Profesionales p ON i.id_profesional = p.id_profesional
        WHERE p.activo = 0
    )
        THROW 50011, 'No se pueden dar turnos con un profesional inactivo.', 1;

    -- Regla 2: un profesional no puede tener turnos superpuestos.
    -- Si el segundo empieza justo cuando termina el primero, SI se permite.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Turnos t ON i.id_profesional = t.id_profesional
        WHERE i.id_turno <> t.id_turno
          AND i.estado <> 'cancelado'
          AND t.estado <> 'cancelado'
          AND i.fecha_hora_inicio < t.fecha_hora_fin
          AND i.fecha_hora_fin > t.fecha_hora_inicio
    )
        THROW 50012, 'El profesional ya tiene un turno en ese horario.', 1;

    -- Si todo esta bien, guardamos el evento de alta.
    INSERT INTO dbo.AuditoriaTurnos
        (id_turno, id_mascota, id_profesional,
         fecha_hora_inicio_anterior, fecha_hora_inicio_nueva, tipo_evento)
    SELECT id_turno, id_mascota, id_profesional,
           NULL, fecha_hora_inicio, 'alta'
    FROM inserted;
END;
GO

-- TRIGGER 2: al modificar turnos
CREATE TRIGGER dbo.trg_Turnos_AfterUpdate
ON dbo.Turnos
AFTER UPDATE
AS
BEGIN
    -- Si se cambia el profesional o el horario, el profesional debe estar activo.
    -- Al cancelar o cobrar un turno viejo, no se necesita volver a asignarlo.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN deleted d ON i.id_turno = d.id_turno
        INNER JOIN dbo.Profesionales p ON i.id_profesional = p.id_profesional
        WHERE i.estado <> 'cancelado'
          AND p.activo = 0
          AND (i.id_profesional <> d.id_profesional
               OR i.fecha_hora_inicio <> d.fecha_hora_inicio
               OR i.fecha_hora_fin <> d.fecha_hora_fin)
    )
        THROW 50013, 'El profesional esta inactivo.', 1;

    -- Comprobamos que el cambio no superponga horarios.
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN dbo.Turnos t ON i.id_profesional = t.id_profesional
        WHERE i.id_turno <> t.id_turno
          AND i.estado <> 'cancelado'
          AND t.estado <> 'cancelado'
          AND i.fecha_hora_inicio < t.fecha_hora_fin
          AND i.fecha_hora_fin > t.fecha_hora_inicio
    )
        THROW 50014, 'El nuevo horario se superpone con otro turno.', 1;

    -- Guardamos la cancelacion cuando pasa de otro estado a cancelado.
    INSERT INTO dbo.AuditoriaTurnos
        (id_turno, id_mascota, id_profesional,
         fecha_hora_inicio_anterior, fecha_hora_inicio_nueva, tipo_evento)
    SELECT i.id_turno, i.id_mascota, i.id_profesional,
           d.fecha_hora_inicio, NULL, 'cancelado'
    FROM inserted i
    INNER JOIN deleted d ON i.id_turno = d.id_turno
    WHERE d.estado <> 'cancelado' AND i.estado = 'cancelado';

    -- Guardamos la reprogramacion cuando cambia la hora de inicio.
    INSERT INTO dbo.AuditoriaTurnos
        (id_turno, id_mascota, id_profesional,
         fecha_hora_inicio_anterior, fecha_hora_inicio_nueva, tipo_evento)
    SELECT i.id_turno, i.id_mascota, i.id_profesional,
           d.fecha_hora_inicio, i.fecha_hora_inicio, 'reprogramacion'
    FROM inserted i
    INNER JOIN deleted d ON i.id_turno = d.id_turno
    WHERE i.fecha_hora_inicio <> d.fecha_hora_inicio;
END;
GO

-- TRIGGER 3: al eliminar fisicamente un turno
CREATE TRIGGER dbo.trg_Turnos_AfterDelete
ON dbo.Turnos
AFTER DELETE
AS
BEGIN
    -- La auditoria conserva el id original, aun cuando ya no exista el turno.
    INSERT INTO dbo.AuditoriaTurnos
        (id_turno, id_mascota, id_profesional,
         fecha_hora_inicio_anterior, fecha_hora_inicio_nueva,
         tipo_evento, motivo_evento)
    SELECT id_turno, id_mascota, id_profesional,
           fecha_hora_inicio, NULL, 'baja', motivo
    FROM deleted;
    -- 'motivo' es el motivo de consulta del turno, no de su eliminacion.
END;
GO
