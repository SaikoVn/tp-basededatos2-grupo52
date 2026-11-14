
IF DB_ID(N'Veterinaria') IS NULL
    EXEC(N'CREATE DATABASE [Veterinaria]');
GO
USE [Veterinaria];
GO

CREATE TABLE dbo.Duenios (
    id_duenio INT IDENTITY(1,1) NOT NULL,
    dni VARCHAR(15) NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    telefono VARCHAR(30) NULL,
    email VARCHAR(100) NULL,
    direccion VARCHAR(150) NULL,
    CONSTRAINT PK_Duenios PRIMARY KEY (id_duenio)
);
GO

CREATE TABLE dbo.Especialidades (
    id_especialidad INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    CONSTRAINT PK_Especialidades PRIMARY KEY (id_especialidad)
);
GO

CREATE TABLE dbo.Mascotas (
    id_mascota INT IDENTITY(1,1) NOT NULL,
    id_duenio INT NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    especie VARCHAR(40) NOT NULL,
    raza VARCHAR(60) NULL,
    fecha_nacimiento DATE NULL,
    sexo CHAR(1) NULL,
    activo BIT NOT NULL,
    CONSTRAINT PK_Mascotas PRIMARY KEY (id_mascota)
);
GO

CREATE TABLE dbo.Profesionales (
    id_profesional INT IDENTITY(1,1) NOT NULL,
    id_especialidad INT NOT NULL,
    matricula VARCHAR(20) NOT NULL,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    telefono VARCHAR(30) NULL,
    email VARCHAR(100) NULL,
    activo BIT NOT NULL,
    CONSTRAINT PK_Profesionales PRIMARY KEY (id_profesional)
);
GO

CREATE TABLE dbo.Turnos (
    id_turno INT IDENTITY(1,1) NOT NULL,
    id_mascota INT NOT NULL,
    id_profesional INT NOT NULL,
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME NOT NULL,
    estado VARCHAR(20) NOT NULL,
    motivo VARCHAR(200) NULL,
    CONSTRAINT PK_Turnos PRIMARY KEY (id_turno)
);
GO

CREATE TABLE dbo.Pagos (
    id_pago INT IDENTITY(1,1) NOT NULL,
    id_turno INT NOT NULL,
    nro_comprobante VARCHAR(20) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago VARCHAR(30) NOT NULL,
    fecha_pago DATETIME NOT NULL,
    CONSTRAINT PK_Pagos PRIMARY KEY (id_pago)
);
GO

CREATE TABLE dbo.HistoriasClinicas (
    id_historia INT IDENTITY(1,1) NOT NULL,
    id_turno INT NOT NULL,
    diagnostico VARCHAR(300) NOT NULL,
    tratamiento VARCHAR(300) NULL,
    observaciones VARCHAR(1000) NULL,
    fecha_registro DATETIME NOT NULL,
    CONSTRAINT PK_HistoriasClinicas PRIMARY KEY (id_historia)
);
GO

CREATE TABLE dbo.AuditoriaTurnos (
    id_auditoria INT IDENTITY(1,1) NOT NULL,
    id_turno INT NOT NULL, -- REFERENCIA HISTORICA: deliberadamente SIN FK a Turnos
    id_mascota INT NOT NULL,
    id_profesional INT NOT NULL,
    fecha_hora_fin_anterior DATETIME NULL,
    fecha_hora_fin_nueva DATETIME NULL,
    fecha_hora_inicio_anterior DATETIME NULL, -- NULL en el evento de alta
    fecha_hora_inicio_nueva DATETIME NULL,    -- NULL en cancelado y baja
    tipo_evento VARCHAR(15) NOT NULL,
    motivo_evento VARCHAR(200) NULL,
    fecha_evento DATETIME NOT NULL,
    CONSTRAINT PK_AuditoriaTurnos PRIMARY KEY (id_auditoria)
);
GO
