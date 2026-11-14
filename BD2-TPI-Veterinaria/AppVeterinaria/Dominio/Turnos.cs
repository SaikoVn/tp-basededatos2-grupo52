using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Turnos
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(int id, string mascota, string profesional, string estado,
            DateTime? desde, DateTime? hasta)
        {
            mascota = mascota ?? "";
            profesional = profesional ?? "";
            estado = estado ?? "";
            DateTime? hastaExclusivo = hasta.HasValue ? hasta.Value.Date.AddDays(1) : (DateTime?)null;

            return db.Consultar(@"SELECT t.id_turno ID, m.nombre Mascota,
                    CONCAT(p.apellido, ', ', p.nombre) Profesional,
                    t.fecha_hora_inicio Inicio, t.fecha_hora_fin Fin,
                    t.estado Estado, t.motivo Motivo,
                    CASE WHEN h.id_turno IS NULL THEN CAST(1 AS bit) ELSE CAST(0 AS bit) END PuedeAtender
                    FROM dbo.Turnos t
                    INNER JOIN dbo.Mascotas m ON m.id_mascota = t.id_mascota
                    INNER JOIN dbo.Profesionales p ON p.id_profesional = t.id_profesional
                    LEFT JOIN dbo.HistoriasClinicas h ON h.id_turno = t.id_turno
                    WHERE (@id = 0 OR t.id_turno = @id)
                      AND (@mascota = '' OR m.nombre LIKE '%' + @mascota + '%')
                      AND (@profesional = '' OR p.nombre LIKE '%' + @profesional + '%'
                           OR p.apellido LIKE '%' + @profesional + '%')
                      AND (@estado = '' OR t.estado = @estado)
                      AND (@desde IS NULL OR t.fecha_hora_inicio >= @desde)
                      AND (@hasta IS NULL OR t.fecha_hora_inicio < @hasta)
                    ORDER BY t.fecha_hora_inicio DESC, t.id_turno DESC",
                Param("@id", id), Param("@mascota", mascota), Param("@profesional", profesional),
                Param("@estado", estado), Param("@desde", desde), Param("@hasta", hastaExclusivo));
        }

        public DataTable OpcionesMascotas()
        {
            return db.Consultar(@"SELECT id_mascota,
                    CONCAT(nombre, ' · #', id_mascota) Mascota
                    FROM dbo.Mascotas WHERE activo = 1 ORDER BY nombre");
        }

        public DataTable OpcionesProfesionales(int incluir = 0)
        {
            return db.Consultar(@"SELECT id_profesional,
                    CONCAT(apellido, ', ', nombre) Profesional
                    FROM dbo.Profesionales
                    WHERE activo = 1 OR id_profesional = @incluir
                    ORDER BY apellido, nombre",
                Param("@incluir", incluir));
        }

        public DataTable Obtener(int id)
        {
            return db.Consultar(@"SELECT id_turno ID, id_profesional ProfesionalId,
                    fecha_hora_inicio Inicio, fecha_hora_fin Fin, motivo Motivo
                    FROM dbo.Turnos WHERE id_turno = @id",
                Param("@id", id));
        }

        public int Crear(int mascota, int profesional, DateTime inicio, DateTime fin, string motivo)
        {
            DataTable resultado = db.Consultar(@"DECLARE @nuevo TABLE(id_turno INT);
                    INSERT dbo.Turnos
                    (id_mascota, id_profesional, fecha_hora_inicio, fecha_hora_fin, motivo)
                    OUTPUT INSERTED.id_turno INTO @nuevo
                    VALUES(@mascota, @profesional, @inicio, @fin, @motivo);
                    SELECT id_turno FROM @nuevo",
                Param("@mascota", mascota), Param("@profesional", profesional),
                Param("@inicio", inicio), Param("@fin", fin), Param("@motivo", motivo));
            return (int)resultado.Rows[0][0];
        }

        public void Editar(int id, int profesional, DateTime inicio, DateTime fin, string motivo)
        {
            db.Ejecutar(@"UPDATE dbo.Turnos
                    SET id_profesional = @profesional, fecha_hora_inicio = @inicio,
                        fecha_hora_fin = @fin, motivo = @motivo
                    WHERE id_turno = @id AND estado = 'pendiente';
                    IF @@ROWCOUNT = 0 THROW 50101, 'El turno ya no está pendiente.', 1;",
                Param("@id", id), Param("@profesional", profesional),
                Param("@inicio", inicio), Param("@fin", fin), Param("@motivo", motivo));
        }

        public void Cancelar(int id)
        {
            db.Ejecutar(@"UPDATE dbo.Turnos SET estado = 'cancelado'
                    WHERE id_turno = @id AND estado = 'pendiente';
                    IF @@ROWCOUNT = 0 THROW 50101, 'El turno ya no está pendiente.', 1;",
                Param("@id", id));
        }

        public void Eliminar(int id)
        {
            db.Ejecutar(@"DELETE dbo.Turnos
                    WHERE id_turno = @id AND estado <> 'atendido';
                    IF @@ROWCOUNT = 0 THROW 50102, 'El turno no existe o ya fue atendido.', 1;",
                Param("@id", id));
        }
    }
}
