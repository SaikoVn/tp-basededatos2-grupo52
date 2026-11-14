using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Pagos
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(int id, int turno, string comprobante, string metodo,
            DateTime? desde, DateTime? hasta)
        {
            comprobante = comprobante ?? "";
            metodo = metodo ?? "";
            DateTime? hastaExclusivo = hasta.HasValue ? hasta.Value.Date.AddDays(1) : (DateTime?)null;
            return db.Consultar(@"SELECT pg.id_pago ID, pg.id_turno Turno, pg.nro_comprobante Comprobante,
                    pg.monto Monto, pg.metodo_pago Método, pg.fecha_pago Fecha,
                    m.nombre Mascota, CONCAT(p.apellido, ', ', p.nombre) Profesional
                    FROM dbo.Pagos pg
                    INNER JOIN dbo.Turnos t ON t.id_turno = pg.id_turno
                    INNER JOIN dbo.Mascotas m ON m.id_mascota = t.id_mascota
                    INNER JOIN dbo.Profesionales p ON p.id_profesional = t.id_profesional
                    WHERE (@id = 0 OR pg.id_pago = @id)
                      AND (@turno = 0 OR pg.id_turno = @turno)
                      AND (@comprobante = '' OR pg.nro_comprobante = @comprobante)
                      AND (@metodo = '' OR pg.metodo_pago = @metodo)
                      AND (@desde IS NULL OR pg.fecha_pago >= @desde)
                      AND (@hasta IS NULL OR pg.fecha_pago < @hasta)
                    ORDER BY pg.fecha_pago DESC, pg.id_pago DESC",
                Param("@id", id), Param("@turno", turno), Param("@comprobante", comprobante),
                Param("@metodo", metodo), Param("@desde", desde), Param("@hasta", hastaExclusivo));
        }

    }
}
