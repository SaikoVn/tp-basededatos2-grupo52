using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Auditoria
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(int id, int turno, string evento, DateTime? desde, DateTime? hasta)
        {
            evento = evento ?? "";
            DateTime? hastaExclusivo = hasta.HasValue ? hasta.Value.Date.AddDays(1) : (DateTime?)null;
            return db.Consultar(@"SELECT id_auditoria ID, id_turno Turno,
                    tipo_evento Evento, fecha_evento Fecha, motivo_evento Motivo
                    FROM dbo.AuditoriaTurnos
                    WHERE (@id = 0 OR id_auditoria = @id)
                      AND (@turno = 0 OR id_turno = @turno)
                      AND (@evento = '' OR tipo_evento = @evento)
                      AND (@desde IS NULL OR fecha_evento >= @desde)
                      AND (@hasta IS NULL OR fecha_evento < @hasta)
                    ORDER BY fecha_evento DESC, id_auditoria DESC",
                Param("@id", id), Param("@turno", turno), Param("@evento", evento),
                Param("@desde", desde), Param("@hasta", hastaExclusivo));
        }
    }
}