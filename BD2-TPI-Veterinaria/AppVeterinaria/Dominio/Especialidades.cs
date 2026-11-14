using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Especialidades
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT id_especialidad ID, nombre Nombre
                    FROM dbo.Especialidades ORDER BY nombre, id_especialidad");
        }

        public DataTable Obtener(int id)
        {
            return db.Consultar(@"SELECT id_especialidad ID, nombre Nombre
                    FROM dbo.Especialidades WHERE id_especialidad = @id",
                Param("@id", id));
        }

        public int Crear(string nombre)
        {
            DataTable resultado = db.Consultar(@"INSERT dbo.Especialidades(nombre)
                    OUTPUT INSERTED.id_especialidad VALUES(@nombre)",
                Param("@nombre", nombre));
            return (int)resultado.Rows[0][0];
        }

        public void Editar(int id, string nombre)
        {
            db.Ejecutar(@"UPDATE dbo.Especialidades SET nombre = @nombre
                    WHERE id_especialidad = @id;
                    IF @@ROWCOUNT = 0 THROW 50202, 'La especialidad ya no existe.', 1;",
                Param("@id", id), Param("@nombre", nombre));
        }
    }
}
