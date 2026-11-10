using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Frecuencia
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT id_mascota ID,mascota Mascota,especie Especie,activo Estado,dni_duenio [DNI del dueño],total_consultas_atendidas [Consultas atendidas] FROM dbo.vw_FrecuenciaConsultasMascotas ORDER BY total_consultas_atendidas DESC,Mascota");
        }
    }
}
