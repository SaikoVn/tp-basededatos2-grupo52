using System;
using System.Data;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaTurnos : PaginaClinica
    {
        private readonly Dominio.Turnos dominio = new Dominio.Turnos();
        private readonly Dominio.Historial dominioAtencion = new Dominio.Historial();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() =>
            {
                Opciones(Mascota, dominio.OpcionesMascotas());
                Opciones(Profesional, dominio.OpcionesProfesionales());
                Cargar();
            });
        }

        private void Cargar()
        {
            DateTime? desde = FechaOpcional(DesdeLista);
            DateTime? hasta = FechaOpcional(HastaLista);
            ValidarRango(desde, hasta);
            Vincular(Tabla, dominio.Listar(IdOpcional(FiltroId),
                Texto(FiltroMascota, false), Texto(FiltroProfesional, false),
                FiltroEstado.SelectedValue, desde, hasta));
        }

        protected void Crear_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                DateTime inicio = Fecha(Inicio);
                DateTime fin = Fecha(Fin);
                ValidarHorario(inicio, fin);
                int id = dominio.Crear(Id(Mascota), Id(Profesional), inicio, fin, Texto(Motivo, false));
                Avisar("Turno registrado. ID: " + id + ".", false);
                Inicio.Text = Fin.Text = Motivo.Text = "";
                Mascota.SelectedIndex = Profesional.SelectedIndex = 0;
                Cargar();
            });
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }

        protected void Tabla_Comando(object sender, GridViewCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            Intentar(() =>
            {
                if (e.CommandName == "Editar")
                {
                    DataTable datos = dominio.Obtener(id);
                    if (datos.Rows.Count == 0) throw new ArgumentException("El turno ya no existe.");
                    DataRow turno = datos.Rows[0];
                    ViewState["TurnoEditando"] = id;
                    Opciones(NuevoProfesional, dominio.OpcionesProfesionales(Convert.ToInt32(turno["ProfesionalId"])));
                    NuevoProfesional.SelectedValue = Convert.ToString(turno["ProfesionalId"]);
                    NuevoInicio.Text = ((DateTime)turno["Inicio"]).ToString("yyyy-MM-ddTHH:mm");
                    NuevoFin.Text = ((DateTime)turno["Fin"]).ToString("yyyy-MM-ddTHH:mm");
                    NuevoMotivo.Text = Convert.ToString(turno["Motivo"]);
                    Edicion.Visible = true;
                }
                else if (e.CommandName == "Atender")
                {
                    DataTable datos = dominio.Obtener(id);
                    if (datos.Rows.Count == 0) throw new ArgumentException("El turno ya no existe.");
                    ViewState["TurnoAtencion"] = id;
                    TurnoAtencion.Text = "#" + id;
                    Diagnostico.Text = Tratamiento.Text = Observaciones.Text = "";
                    ComprobanteAtencion.Text = MontoAtencion.Text = "";
                    MetodoAtencion.SelectedIndex = 0;
                    Atencion.Visible = true;
                }
                else if (e.CommandName == "Cancelar")
                {
                    dominio.Cancelar(id);
                    Avisar("Turno cancelado. ID: " + id + ".", false);
                }
                else if (e.CommandName == "Eliminar")
                {
                    dominio.Eliminar(id);
                    Avisar("Turno eliminado. ID: " + id + ".", false);
                }
                Cargar();
            });
        }

        protected void GuardarHorario_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                if (ViewState["TurnoEditando"] == null)
                    throw new ArgumentException("Volvé a seleccionar el turno.");
                DateTime inicio = Fecha(NuevoInicio);
                DateTime fin = Fecha(NuevoFin);
                ValidarHorario(inicio, fin);
                int id = (int)ViewState["TurnoEditando"];
                dominio.Editar(id, Id(NuevoProfesional),
                    inicio, fin, Texto(NuevoMotivo, false));
                Edicion.Visible = false;
                Avisar("Turno actualizado. ID: " + id + ".", false);
                Cargar();
            });
        }

        protected void Volver_Click(object sender, EventArgs e)
        {
            Edicion.Visible = false;
            ViewState.Remove("TurnoEditando");
        }

        protected void GuardarAtencion_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                if (ViewState["TurnoAtencion"] == null)
                    throw new ArgumentException("Volvé a seleccionar el turno.");
                decimal monto;
                if (!decimal.TryParse(MontoAtencion.Text, NumberStyles.Number,
                    CultureInfo.InvariantCulture, out monto) || monto <= 0)
                    throw new ArgumentException("Ingresá un monto mayor a cero.");
                int id = (int)ViewState["TurnoAtencion"];
                DataTable resultado = dominioAtencion.Registrar(id,
                    Texto(Diagnostico), Texto(Tratamiento, false), Texto(Observaciones, false),
                    Texto(ComprobanteAtencion), monto, MetodoAtencion.SelectedValue);
                int historia = Convert.ToInt32(resultado.Rows[0]["Historia"]);
                int pago = Convert.ToInt32(resultado.Rows[0]["Pago"]);
                Atencion.Visible = false;
                ViewState.Remove("TurnoAtencion");
                Avisar("Atención y pago registrados. Turno ID: " + id + ", ficha ID: " + historia
                    + ", pago ID: " + pago + ". El turno quedó atendido.", false);
                Cargar();
            });
        }

        protected void CancelarAtencion_Click(object sender, EventArgs e)
        {
            Atencion.Visible = false;
            ViewState.Remove("TurnoAtencion");
        }

        private static void ValidarRango(DateTime? desde, DateTime? hasta)
        {
            if (desde.HasValue && hasta.HasValue && desde.Value.Date > hasta.Value.Date)
                throw new ArgumentException("La fecha desde debe ser anterior o igual a la fecha hasta.");
        }

        private static void ValidarHorario(DateTime inicio, DateTime fin)
        {
            if (inicio.Date != fin.Date)
                throw new ArgumentException("El inicio y el fin del turno deben ser el mismo día.");
            if (fin <= inicio)
                throw new ArgumentException("La hora de fin debe ser posterior a la hora de inicio.");
        }
    }
}
