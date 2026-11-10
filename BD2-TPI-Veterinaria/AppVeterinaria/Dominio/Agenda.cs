using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Agenda
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT id_turno Turno,fecha_hora_inicio Inicio,fecha_hora_fin Fin,mascota Mascota,CONCAT(nombre_duenio,' ',apellido_duenio) [Dueño],CONCAT(nombre_profesional,' ',apellido_profesional) Profesional,especialidad Especialidad,estado Estado,motivo Motivo
                    FROM dbo.vw_AgendaTurnosActivos ORDER BY Inicio");
        }
    }
}
