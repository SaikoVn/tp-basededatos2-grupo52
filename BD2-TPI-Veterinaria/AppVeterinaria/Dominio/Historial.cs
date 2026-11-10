using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Historial
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(int id = 0)
        {
            return db.Consultar(@"SELECT id_historia Historia,mascota Mascota,mascota_activa Estado,CONCAT(nombre_duenio,' ',apellido_duenio) [Dueño],id_turno Turno,fecha_hora_inicio Inicio,CONCAT(nombre_profesional,' ',apellido_profesional) Profesional,fecha_registro Registro,diagnostico [Diagnóstico],tratamiento Tratamiento,observaciones Observaciones
                    FROM dbo.vw_HistorialClinicoPorMascota WHERE @id=0 OR id_mascota=@id ORDER BY Registro DESC", Param("@id", id));
        }
    }
}
