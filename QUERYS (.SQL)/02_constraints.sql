02 - FOREIGN KEY, UNIQUE, CHECK, DEFAULT, indices
USE [Veterinaria];
GO
-- UNIQUE (maximo UN pago por turno)
ALTER TABLE dbo.Duenios ADD CONSTRAINT UQ_Duenios_Dni UNIQUE (dni);
ALTER TABLE dbo.Especialidades ADD CONSTRAINT UQ_Especialidades_Nombre UNIQUE (nombre);
ALTER TABLE dbo.Profesionales ADD CONSTRAINT UQ_Profesionales_Matricula UNIQUE (matricula);
ALTER TABLE dbo.Pagos ADD CONSTRAINT UQ_Pagos_NroComprobante UNIQUE (nro_comprobante);
ALTER TABLE dbo.Pagos ADD CONSTRAINT UQ_Pagos_IdTurno UNIQUE (id_turno);
ALTER TABLE dbo.HistoriasClinicas ADD CONSTRAINT UQ_HistoriasClinicas_IdTurno UNIQUE (id_turno);
GO

-- FK reales: 8. AuditoriaTurnos.id_turno NO tiene FK por las eliminaciones fisicas.
ALTER TABLE dbo.Mascotas ADD CONSTRAINT FK_Mascotas_Duenios
    FOREIGN KEY (id_duenio) REFERENCES dbo.Duenios(id_duenio);
ALTER TABLE dbo.Profesionales ADD CONSTRAINT FK_Profesionales_Especialidades
    FOREIGN KEY (id_especialidad) REFERENCES dbo.Especialidades(id_especialidad);
ALTER TABLE dbo.Turnos ADD CONSTRAINT FK_Turnos_Mascotas
    FOREIGN KEY (id_mascota) REFERENCES dbo.Mascotas(id_mascota);
ALTER TABLE dbo.Turnos ADD CONSTRAINT FK_Turnos_Profesionales
    FOREIGN KEY (id_profesional) REFERENCES dbo.Profesionales(id_profesional);
ALTER TABLE dbo.Pagos ADD CONSTRAINT FK_Pagos_Turnos
    FOREIGN KEY (id_turno) REFERENCES dbo.Turnos(id_turno);
ALTER TABLE dbo.HistoriasClinicas ADD CONSTRAINT FK_HistoriasClinicas_Turnos
    FOREIGN KEY (id_turno) REFERENCES dbo.Turnos(id_turno);
ALTER TABLE dbo.AuditoriaTurnos ADD CONSTRAINT FK_AuditoriaTurnos_Mascotas
    FOREIGN KEY (id_mascota) REFERENCES dbo.Mascotas(id_mascota);
ALTER TABLE dbo.AuditoriaTurnos ADD CONSTRAINT FK_AuditoriaTurnos_Profesionales
    FOREIGN KEY (id_profesional) REFERENCES dbo.Profesionales(id_profesional);
GO

-- CHECKS
ALTER TABLE dbo.Mascotas ADD CONSTRAINT CK_Mascotas_Sexo
    CHECK (sexo IN ('M', 'F'));
ALTER TABLE dbo.Turnos ADD CONSTRAINT CK_Turnos_Estado
    CHECK (estado IN ('pendiente', 'atendido', 'cancelado'));
ALTER TABLE dbo.Turnos ADD CONSTRAINT CK_Turnos_RangoHorario
    CHECK (fecha_hora_fin > fecha_hora_inicio);
ALTER TABLE dbo.Pagos ADD CONSTRAINT CK_Pagos_Monto
    CHECK (monto > 0);
ALTER TABLE dbo.Pagos ADD CONSTRAINT CK_Pagos_MetodoPago
    CHECK (metodo_pago IN ('efectivo', 'tarjeta', 'transferencia'));
ALTER TABLE dbo.AuditoriaTurnos ADD CONSTRAINT CK_AuditoriaTurnos_TipoEvento
    CHECK (tipo_evento IN ('alta', 'cancelado', 'reprogramacion', 'baja'));
-- Refuerza el significado de horarios anterior/nuevo para cada evento.
ALTER TABLE dbo.AuditoriaTurnos ADD CONSTRAINT CK_AuditoriaTurnos_FechasEvento
    CHECK (
        (tipo_evento = 'alta'
            AND fecha_hora_inicio_anterior IS NULL
            AND fecha_hora_inicio_nueva IS NOT NULL)
        OR (tipo_evento = 'reprogramacion'
            AND fecha_hora_inicio_anterior IS NOT NULL
            AND fecha_hora_inicio_nueva IS NOT NULL
            AND fecha_hora_inicio_anterior <> fecha_hora_inicio_nueva)
        OR (tipo_evento IN ('cancelado', 'baja')
            AND fecha_hora_inicio_anterior IS NOT NULL
            AND fecha_hora_inicio_nueva IS NULL)
    );
GO

-- DEFAULT
ALTER TABLE dbo.Mascotas ADD CONSTRAINT DF_Mascotas_Activo
    DEFAULT (1) FOR activo;
ALTER TABLE dbo.Profesionales ADD CONSTRAINT DF_Profesionales_Activo
    DEFAULT (1) FOR activo;
ALTER TABLE dbo.Turnos ADD CONSTRAINT DF_Turnos_Estado
    DEFAULT ('pendiente') FOR estado;
ALTER TABLE dbo.Pagos ADD CONSTRAINT DF_Pagos_FechaPago
    DEFAULT (GETDATE()) FOR fecha_pago;
ALTER TABLE dbo.HistoriasClinicas ADD CONSTRAINT DF_HistoriasClinicas_FechaRegistro
    DEFAULT (GETDATE()) FOR fecha_registro;
ALTER TABLE dbo.AuditoriaTurnos ADD CONSTRAINT DF_AuditoriaTurnos_FechaEvento
    DEFAULT (GETDATE()) FOR fecha_evento;
GO

-- Indice para comprobar agenda / buscar superposiciones por profesional.
CREATE INDEX IX_Turnos_Profesional_Inicio
    ON dbo.Turnos (id_profesional, fecha_hora_inicio)
    INCLUDE (fecha_hora_fin, estado);
GO
