using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Duenios
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string dni, string nombre, string apellido)
        {
            dni = dni ?? "";
            nombre = nombre ?? "";
            apellido = apellido ?? "";
            return db.Consultar(@"SELECT id_duenio ID, dni DNI, nombre Nombre, apellido Apellido,
                    telefono Teléfono, email Correo, direccion Dirección
                    FROM dbo.Duenios
                    WHERE (@dni = '' OR dni = @dni)
                      AND (@nombre = '' OR nombre LIKE '%' + @nombre + '%')
                      AND (@apellido = '' OR apellido LIKE '%' + @apellido + '%')
                    ORDER BY apellido, nombre, id_duenio",
                Param("@dni", dni), Param("@nombre", nombre), Param("@apellido", apellido));
        }

        public int Crear(string dni, string nombre, string apellido,
            string telefono, string email, string direccion)
        {
            DataTable resultado = db.Consultar(@"INSERT dbo.Duenios(dni, nombre, apellido, telefono, email, direccion)
                    OUTPUT INSERTED.id_duenio
                    VALUES(@dni, @nombre, @apellido, @telefono, @email, @direccion)",
                Param("@dni", dni), Param("@nombre", nombre), Param("@apellido", apellido),
                Param("@telefono", telefono), Param("@email", email), Param("@direccion", direccion));
            return (int)resultado.Rows[0][0];
        }

        public DataTable Obtener(int id)
        {
            return db.Consultar(@"SELECT id_duenio ID, dni DNI, nombre Nombre, apellido Apellido,
                    telefono Telefono, email Correo, direccion Direccion
                    FROM dbo.Duenios WHERE id_duenio = @id", Param("@id", id));
        }

        public void Editar(int id, string dni, string nombre, string apellido,
            string telefono, string email, string direccion)
        {
            db.Ejecutar(@"UPDATE dbo.Duenios SET dni = @dni, nombre = @nombre,
                    apellido = @apellido, telefono = @telefono, email = @email, direccion = @direccion
                    WHERE id_duenio = @id;
                    IF @@ROWCOUNT = 0 THROW 50301, 'El dueño ya no existe.', 1;",
                Param("@id", id), Param("@dni", dni), Param("@nombre", nombre),
                Param("@apellido", apellido), Param("@telefono", telefono),
                Param("@email", email), Param("@direccion", direccion));
        }
    }
}
