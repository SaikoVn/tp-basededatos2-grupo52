using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Profesionales
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string matricula, string nombre, string apellido, string especialidad)
        {
            matricula = matricula ?? "";
            nombre = nombre ?? "";
            apellido = apellido ?? "";
            especialidad = especialidad ?? "";
            return db.Consultar(@"SELECT p.id_profesional ID, p.matricula Matrícula,
                    CONCAT(p.apellido, ', ', p.nombre) Profesional, e.nombre Especialidad,
                    p.telefono Teléfono, p.email Correo, p.activo Estado
                    FROM dbo.Profesionales p
                    INNER JOIN dbo.Especialidades e ON e.id_especialidad = p.id_especialidad
                    WHERE (@matricula = '' OR p.matricula = @matricula)
                      AND (@nombre = '' OR p.nombre LIKE '%' + @nombre + '%')
                      AND (@apellido = '' OR p.apellido LIKE '%' + @apellido + '%')
                      AND (@especialidad = '' OR e.nombre LIKE '%' + @especialidad + '%')
                    ORDER BY p.apellido, p.nombre, p.id_profesional",
                Param("@matricula", matricula), Param("@nombre", nombre),
                Param("@apellido", apellido), Param("@especialidad", especialidad));
        }

        public DataTable Especialidades()
        {
            return db.Consultar(@"SELECT id_especialidad, nombre FROM dbo.Especialidades ORDER BY nombre");
        }

        public int Crear(int especialidad, string matricula, string nombre, string apellido,
            string telefono, string correo)
        {
            DataTable resultado = db.Consultar(@"INSERT dbo.Profesionales
                    (id_especialidad, matricula, nombre, apellido, telefono, email, activo)
                    OUTPUT INSERTED.id_profesional
                    VALUES(@especialidad, @matricula, @nombre, @apellido, @telefono, @correo, 1)",
                Param("@especialidad", especialidad), Param("@matricula", matricula),
                Param("@nombre", nombre), Param("@apellido", apellido),
                Param("@telefono", telefono), Param("@correo", correo));
            return (int)resultado.Rows[0][0];
        }

        public DataTable Obtener(int id)
        {
            return db.Consultar(@"SELECT id_profesional ID, id_especialidad EspecialidadId,
                    matricula Matricula, nombre Nombre, apellido Apellido,
                    telefono Telefono, email Correo
                    FROM dbo.Profesionales WHERE id_profesional = @id", Param("@id", id));
        }

        public void Editar(int id, int especialidad, string matricula, string nombre, string apellido,
            string telefono, string correo)
        {
            db.Ejecutar(@"UPDATE dbo.Profesionales SET id_especialidad = @especialidad,
                    matricula = @matricula, nombre = @nombre, apellido = @apellido,
                    telefono = @telefono, email = @correo
                    WHERE id_profesional = @id;
                    IF @@ROWCOUNT = 0 THROW 50303, 'El profesional ya no existe.', 1;",
                Param("@id", id), Param("@especialidad", especialidad),
                Param("@matricula", matricula), Param("@nombre", nombre),
                Param("@apellido", apellido), Param("@telefono", telefono), Param("@correo", correo));
        }

        public void CambiarEstado(int id, bool activo)
        {
            db.Ejecutar(@"IF @activo = 0 AND EXISTS
                    (SELECT 1 FROM dbo.Turnos WHERE id_profesional = @id AND estado = 'pendiente')
                    THROW 50201, 'Resolvé los turnos pendientes antes de desactivar al profesional.', 1;
                    UPDATE dbo.Profesionales SET activo = @activo WHERE id_profesional = @id",
                Param("@id", id), Param("@activo", activo));
        }
    }
}
