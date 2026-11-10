using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Turnos
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT t.id_turno ID,m.nombre Mascota,CONCAT(p.apellido,', ',p.nombre) Profesional,t.fecha_hora_inicio Inicio,t.fecha_hora_fin Fin,t.estado Estado,t.motivo Motivo
                    FROM dbo.Turnos t JOIN dbo.Mascotas m ON m.id_mascota=t.id_mascota JOIN dbo.Profesionales p ON p.id_profesional=t.id_profesional ORDER BY Inicio DESC,ID DESC");
        }
        
        public DataTable OpcionesMascotas()
        {
            return db.Consultar("SELECT id_mascota,CONCAT(nombre,' · #',id_mascota) etiqueta FROM dbo.Mascotas WHERE activo=1 ORDER BY etiqueta");
        }
        
        public DataTable OpcionesProfesionales()
        {
            return db.Consultar("SELECT id_profesional,CONCAT(apellido,', ',nombre,' · ',matricula) etiqueta FROM dbo.Profesionales WHERE activo=1 ORDER BY etiqueta");
        }
        
        public void CrearTurno(int mascota, int profesional, DateTime inicio, DateTime fin, string motivo)
        {
            db.Ejecutar(@"INSERT dbo.Turnos(id_mascota,id_profesional,fecha_hora_inicio,fecha_hora_fin,motivo)
                    SELECT id_mascota,@profesional,@inicio,@fin,@motivo FROM dbo.Mascotas WITH (HOLDLOCK) WHERE id_mascota=@mascota AND activo=1;
                    IF @@ROWCOUNT=0 THROW 50100, 'Seleccioná una mascota activa.', 1;",
                    Param("@mascota", mascota),
                    Param("@profesional", profesional),
                    Param("@inicio", inicio),
                    Param("@fin", fin),
                    Param("@motivo", motivo));
        }
        
        public void Reprogramar(int id, DateTime inicio, DateTime fin)
        {
            db.Ejecutar(@"UPDATE dbo.Turnos SET fecha_hora_inicio=@inicio,fecha_hora_fin=@fin WHERE id_turno=@id AND estado='pendiente'; IF @@ROWCOUNT=0 THROW 50101, 'El turno ya no está pendiente.', 1;",
                    Param("@id", id),
                    Param("@inicio", inicio),
                    Param("@fin", fin));
        }
        
        public void Cancelar(int id)
        {
            db.Ejecutar(@"UPDATE dbo.Turnos SET estado='cancelado' WHERE id_turno=@id AND estado='pendiente'; IF @@ROWCOUNT=0 THROW 50101, 'El turno ya no está pendiente.', 1;",
                    Param("@id", id));
        }
        
        public void Eliminar(int id)
        {
            db.Ejecutar(@"DELETE FROM dbo.Turnos WHERE id_turno=@id; IF @@ROWCOUNT=0 THROW 50102, 'El turno ya no existe.', 1;",
                    Param("@id", id));
        }
    }
}
