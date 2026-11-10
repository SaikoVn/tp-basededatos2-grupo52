using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Profesionales
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT p.id_profesional ID,p.matricula [Matrícula],CONCAT(p.apellido,', ',p.nombre) Profesional,e.nombre Especialidad,p.activo Estado
                    FROM dbo.Profesionales p JOIN dbo.Especialidades e ON e.id_especialidad=p.id_especialidad ORDER BY Profesional");
        }
        
        public void EstadoProfesional(int id, bool activo)
        {
            db.Ejecutar(@"UPDATE dbo.Profesionales SET activo=@activo WHERE id_profesional=@id",
                    Param("@id", id),
                    Param("@activo", activo));
        }
    }
}
