using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Auditoria
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT a.id_auditoria ID,a.id_turno [Turno histórico],m.nombre Mascota,CONCAT(p.apellido,', ',p.nombre) Profesional,a.tipo_evento Evento,a.fecha_evento Fecha,a.fecha_hora_inicio_anterior [Inicio anterior],a.fecha_hora_inicio_nueva [Inicio nuevo],a.motivo_evento Motivo
                    FROM dbo.AuditoriaTurnos a JOIN dbo.Mascotas m ON m.id_mascota=a.id_mascota JOIN dbo.Profesionales p ON p.id_profesional=a.id_profesional ORDER BY a.fecha_evento DESC,a.id_auditoria DESC");
        }
    }
}
