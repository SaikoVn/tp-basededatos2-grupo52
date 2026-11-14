using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Historial
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Registrar(int turno, string diagnostico, string tratamiento, string observaciones,
            string comprobante, decimal monto, string metodo)
        {
            return db.Consultar(@"SET XACT_ABORT ON;
                    BEGIN TRANSACTION;
                    IF NOT EXISTS (SELECT 1 FROM dbo.Turnos WHERE id_turno = @turno AND estado <> 'cancelado')
                        THROW 50104, 'El turno no existe o está cancelado.', 1;
                    IF EXISTS (SELECT 1 FROM dbo.HistoriasClinicas WHERE id_turno = @turno)
                        THROW 50105, 'Este turno ya tiene una atención registrada.', 1;
                    EXEC dbo.sp_RegistrarPagoYAtenderTurno
                        @id_turno = @turno, @nro_comprobante = @comprobante,
                        @monto = @monto, @metodo_pago = @metodo;
                    INSERT dbo.HistoriasClinicas(id_turno, diagnostico, tratamiento, observaciones)
                    VALUES(@turno, @diagnostico, @tratamiento, @observaciones);
                    DECLARE @historia INT = CONVERT(INT, SCOPE_IDENTITY());
                    COMMIT TRANSACTION;
                    SELECT @historia Historia,
                        (SELECT id_pago FROM dbo.Pagos WHERE id_turno = @turno) Pago;",
                Param("@turno", turno), Param("@diagnostico", diagnostico),
                Param("@tratamiento", tratamiento), Param("@observaciones", observaciones),
                Param("@comprobante", comprobante), Param("@monto", monto), Param("@metodo", metodo));
        }

        public DataTable Listar(string mascota, string duenio, int turno,
            DateTime? desde, DateTime? hasta)
        {
            mascota = mascota ?? "";
            duenio = duenio ?? "";
            DateTime? hastaExclusivo = hasta.HasValue ? hasta.Value.Date.AddDays(1) : (DateTime?)null;
            return db.Consultar(@"SELECT id_historia Historia, mascota Mascota, especie Especie,
                    mascota_activa Estado, CONCAT(nombre_duenio, ' ', apellido_duenio) Dueño,
                    id_turno Turno, fecha_hora_inicio Inicio,
                    CONCAT(nombre_profesional, ' ', apellido_profesional) Profesional,
                    fecha_registro Registro, diagnostico Diagnóstico,
                    tratamiento Tratamiento, observaciones Observaciones
                    FROM dbo.vw_HistorialClinicoPorMascota
                    WHERE (@mascota = '' OR mascota LIKE '%' + @mascota + '%')
                      AND (@duenio = '' OR nombre_duenio LIKE '%' + @duenio + '%'
                           OR apellido_duenio LIKE '%' + @duenio + '%')
                      AND (@turno = 0 OR id_turno = @turno)
                      AND (@desde IS NULL OR fecha_registro >= @desde)
                      AND (@hasta IS NULL OR fecha_registro < @hasta)
                    ORDER BY fecha_registro DESC, id_historia DESC",
                Param("@mascota", mascota), Param("@duenio", duenio), Param("@turno", turno),
                Param("@desde", desde), Param("@hasta", hastaExclusivo));
        }
    }
}
