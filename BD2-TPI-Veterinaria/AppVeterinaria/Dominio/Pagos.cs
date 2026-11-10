using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Pagos
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT pg.id_pago ID,t.id_turno Turno,pg.nro_comprobante Comprobante,pg.monto Monto,pg.metodo_pago [Método],pg.fecha_pago Fecha,t.estado [Estado del turno]
                    FROM dbo.Pagos pg JOIN dbo.Turnos t ON t.id_turno=pg.id_turno ORDER BY ID DESC");
        }
        
        public DataTable OpcionesTurnos()
        {
            return db.Consultar("SELECT t.id_turno,CONCAT('#',t.id_turno,' · ',m.nombre,' · ',CONVERT(varchar(16),t.fecha_hora_inicio,120),' · ',t.estado) etiqueta FROM dbo.Turnos t JOIN dbo.Mascotas m ON m.id_mascota=t.id_mascota ORDER BY t.fecha_hora_inicio DESC");
        }
        
        public void RegistrarPago(int turno, string comprobante, decimal monto, string metodo)
        {
            db.Ejecutar(@"EXEC dbo.sp_RegistrarPagoYAtenderTurno @id_turno=@turno, @nro_comprobante=@comprobante, @monto=@monto, @metodo_pago=@metodo",
                    Param("@turno", turno),
                    Param("@comprobante", comprobante),
                    Param("@monto", monto),
                    Param("@metodo", metodo));
        }
    }
}
