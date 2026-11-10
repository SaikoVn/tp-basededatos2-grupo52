-- FUNCION: cantidad de consultas atendidas de una mascota
-- Se usa en las vistas 04.
USE Veterinaria;
GO

CREATE FUNCTION dbo.fn_CantidadConsultasMascota (@id_mascota INT)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;

    -- Contamos los turnos que se marcaron como atendidos.
    SELECT @cantidad = COUNT(*)
    FROM dbo.Turnos
    WHERE id_mascota = @id_mascota
      AND estado = 'atendido';

    RETURN @cantidad;
END;
GO
