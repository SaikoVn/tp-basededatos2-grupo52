using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Agenda
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string mascota, string profesional, string estado,
            DateTime? desde, DateTime? hasta)
        {
            mascota = mascota ?? "";
            profesional = profesional ?? "";
            estado = estado ?? "";
            DateTime? hastaExclusivo = hasta.HasValue ? hasta.Value.Date.AddDays(1) : (DateTime?)null;
            return db.Consultar(@"SELECT id_turno Turno, fecha_hora_inicio Inicio,
                    fecha_hora_fin Fin, mascota Mascota,
                    CONCAT(nombre_duenio, ' ', apellido_duenio) Dueño,
                    CONCAT(nombre_profesional, ' ', apellido_profesional) Profesional,
                    especialidad Especialidad, estado Estado, motivo Motivo
                    FROM dbo.vw_AgendaTurnosActivos
                    WHERE (@mascota = '' OR mascota LIKE '%' + @mascota + '%')
                      AND (@profesional = '' OR nombre_profesional LIKE '%' + @profesional + '%'
                           OR apellido_profesional LIKE '%' + @profesional + '%')
                      AND (@estado = '' OR estado = @estado)
                      AND (@desde IS NULL OR fecha_hora_inicio >= @desde)
                      AND (@hasta IS NULL OR fecha_hora_inicio < @hasta)
                    ORDER BY fecha_hora_inicio, id_turno",
                Param("@mascota", mascota), Param("@profesional", profesional),
                Param("@estado", estado), Param("@desde", desde), Param("@hasta", hastaExclusivo));
        }
    }
}