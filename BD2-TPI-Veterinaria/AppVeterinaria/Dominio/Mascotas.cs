using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Mascotas
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string q)
        {
            return db.Consultar(@"SELECT m.id_mascota ID,m.nombre Mascota,m.especie Especie,m.raza Raza,m.sexo Sexo,m.fecha_nacimiento Nacimiento,
                    CONCAT(d.apellido,', ',d.nombre) [Dueño],m.activo Estado
                    FROM dbo.Mascotas m JOIN dbo.Duenios d ON d.id_duenio=m.id_duenio
                    WHERE CHARINDEX(@q,m.nombre)>0 OR @q='' ORDER BY m.nombre,ID", Param("@q", q ?? ""));
        }
        
        public DataTable OpcionesDuenios()
        {
            return db.Consultar("SELECT id_duenio,CONCAT(apellido,', ',nombre,' · ',dni) etiqueta FROM dbo.Duenios ORDER BY etiqueta");
        }
        
        public void CrearMascota(int duenio, string nombre, string especie, string raza, DateTime? nacimiento, string sexo)
        {
            db.Ejecutar(@"INSERT dbo.Mascotas(id_duenio,nombre,especie,raza,fecha_nacimiento,sexo) VALUES(@duenio,@nombre,@especie,@raza,@nacimiento,@sexo)",
                    Param("@duenio", duenio),
                    Param("@nombre", nombre),
                    Param("@especie", especie),
                    Param("@raza", raza),
                    Param("@nacimiento", nacimiento),
                    Param("@sexo", sexo));
        }
        
        public void BajaMascota(int id)
        {
            db.Ejecutar(@"UPDATE dbo.Mascotas SET activo=0 WHERE id_mascota=@id",
                    Param("@id", id));
        }
    }
}
