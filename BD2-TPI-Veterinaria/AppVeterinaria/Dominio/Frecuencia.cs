using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Frecuencia
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string mascota, string especie, string dni, string estado)
        {
            mascota = mascota ?? "";
            especie = especie ?? "";
            dni = dni ?? "";
            estado = estado ?? "";
            return db.Consultar(@"SELECT id_mascota ID, mascota Mascota, especie Especie,
                    activo Estado, dni_duenio [DNI del dueño],
                    total_consultas_atendidas [Consultas atendidas]
                    FROM dbo.vw_FrecuenciaConsultasMascotas
                    WHERE (@mascota = '' OR mascota LIKE '%' + @mascota + '%')
                      AND (@especie = '' OR especie LIKE '%' + @especie + '%')
                      AND (@dni = '' OR dni_duenio = @dni)
                      AND (@estado = '' OR CONVERT(varchar(1), activo) = @estado)
                    ORDER BY total_consultas_atendidas DESC, mascota, id_mascota",
                Param("@mascota", mascota), Param("@especie", especie),
                Param("@dni", dni), Param("@estado", estado));
        }
    }
}