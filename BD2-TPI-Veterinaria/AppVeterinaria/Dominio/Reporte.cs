using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Reporte
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable OpcionesProfesionales()
        {
            return db.Consultar(@"SELECT id_profesional,
                    CONCAT(apellido, ', ', nombre, ' · ', matricula) Profesional
                    FROM dbo.Profesionales ORDER BY apellido, nombre");
        }

        public DataTable Consultar(int profesional, DateTime desde, DateTime hasta)
        {
            return db.Consultar(@"EXEC dbo.sp_ReporteTurnosProfesional
                    @id_profesional = @profesional, @desde = @desde,
                    @hasta_exclusivo = @hasta",
                Param("@profesional", profesional), Param("@desde", desde.Date),
                Param("@hasta", hasta.Date.AddDays(1)));
        }
    }
}