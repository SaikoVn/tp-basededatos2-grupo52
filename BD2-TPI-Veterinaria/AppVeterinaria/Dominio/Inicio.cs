using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Inicio
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT (SELECT COUNT(*) FROM dbo.Mascotas) [Mascotas registradas],
                    (SELECT COUNT(*) FROM dbo.Profesionales WHERE activo=1) [Profesionales activos],
                    (SELECT COUNT(*) FROM dbo.Turnos WHERE estado='pendiente') [Turnos pendientes],
                    (SELECT COUNT(*) FROM dbo.Pagos) [Pagos registrados]");
        }
    }
}
