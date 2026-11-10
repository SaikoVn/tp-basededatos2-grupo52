using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Duenios
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string q)
        {
            return db.Consultar(@"SELECT id_duenio ID, dni DNI, nombre Nombre, apellido Apellido, telefono [Teléfono], email Correo, direccion [Dirección]
                    FROM dbo.Duenios WHERE CHARINDEX(@q, CONCAT(nombre,' ',apellido))>0 OR @q='' ORDER BY apellido,nombre", Param("@q", q ?? ""));
        }
        
        public void CrearDuenio(string dni, string nombre, string apellido, string telefono, string email, string direccion)
        {
            db.Ejecutar(@"INSERT dbo.Duenios(dni,nombre,apellido,telefono,email,direccion) VALUES(@dni,@nombre,@apellido,@telefono,@email,@direccion)",
                    Param("@dni", dni),
                    Param("@nombre", nombre),
                    Param("@apellido", apellido),
                    Param("@telefono", telefono),
                    Param("@email", email),
                    Param("@direccion", direccion));
        }
    }
}
