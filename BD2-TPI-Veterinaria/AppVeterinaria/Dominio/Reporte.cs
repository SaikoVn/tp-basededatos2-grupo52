using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Reporte
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable OpcionesProfesionales() => db.Consultar("SELECT id_profesional,CONCAT(apellido,', ',nombre,' · ',matricula) etiqueta FROM dbo.Profesionales ORDER BY etiqueta");
        
        public DataTable Consultar(int profesional, DateTime desde, DateTime hasta)
        {
            return db.Consultar("EXEC dbo.sp_ReporteTurnosProfesional @id_profesional, @desde, @hasta_exclusivo",
                Param("@id_profesional", profesional), Param("@desde", desde.Date), Param("@hasta_exclusivo", hasta.Date.AddDays(1)));
        }
    }
}
