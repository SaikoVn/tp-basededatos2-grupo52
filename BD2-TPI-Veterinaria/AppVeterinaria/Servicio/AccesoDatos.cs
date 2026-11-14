using System.Configuration;
using System.Data;
using Microsoft.Data.SqlClient;

namespace Servicio
{
    // Abre una conexión por operación y recibe consultas parametrizadas.
    public class AccesoDatos
    {
        private readonly string cadena =
            ConfigurationManager.ConnectionStrings["Veterinaria"].ConnectionString;

        public DataTable Consultar(string sql, params SqlParameter[] parametros)
        {
            using (var conexion = new SqlConnection(cadena))
            using (var comando = new SqlCommand(sql, conexion))
            {
                comando.Parameters.AddRange(parametros);
                conexion.Open();
                using (var lector = comando.ExecuteReader())
                {
                    var tabla = new DataTable();
                    tabla.Load(lector);
                    return tabla;
                }
            }
        }

        public void Ejecutar(string sql, params SqlParameter[] parametros)
        {
            using (var conexion = new SqlConnection(cadena))
            using (var comando = new SqlCommand(sql, conexion))
            {
                comando.Parameters.AddRange(parametros);
                conexion.Open();
                comando.ExecuteNonQuery();
            }
        }

        public static SqlParameter Param(string nombre, object valor)
        {
            return new SqlParameter(nombre, valor ?? System.DBNull.Value);
        }
    }
}