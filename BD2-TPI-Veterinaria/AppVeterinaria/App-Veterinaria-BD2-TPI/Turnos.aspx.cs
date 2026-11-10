using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaTurnos : PaginaClinica
    {
        private readonly Dominio.Turnos dominio = new Dominio.Turnos();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() => {
                Opciones(Mascota, dominio.OpcionesMascotas());
                Opciones(Profesional, dominio.OpcionesProfesionales());
                Cargar();
            });
        }

        private void Cargar()
        {
            var datos = dominio.Listar();
            Tabla.DataSource = datos;
            Tabla.DataBind();
        }

        protected void Crear_Click(object sender, EventArgs e)
        {
            Guardar(() => {
                VerificarHorario(Inicio, Fin);
                dominio.CrearTurno(Id(Mascota), Id(Profesional), Fecha(Inicio), Fecha(Fin), Texto(Motivo, false));
            }, "Turno registrado.");
        }
        
        protected void GuardarHorario_Click(object sender, EventArgs e)
        {
            Guardar(() => {
                VerificarHorario(NuevoInicio, NuevoFin);
                dominio.Reprogramar((int)ViewState["Turno"], Fecha(NuevoInicio), Fecha(NuevoFin));
            }, "Turno reprogramado.");
        }
        
        protected void Volver_Click(object sender, EventArgs e)
        {
            Edicion.Visible = false;
        }
        
        private void VerificarHorario(TextBox inicio, TextBox fin)
        {
            if (Fecha(fin) <= Fecha(inicio)) throw new ArgumentException("El fin debe ser posterior al inicio.");
        }
        
        protected void Tabla_Comando(object sender, GridViewCommandEventArgs e)
        {
            var fila = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            var clave = Tabla.DataKeys[fila.RowIndex];
            int id = (int)clave.Values["ID"];
            switch (e.CommandName)
            {
                case "EditarHorario":
                    ViewState["Turno"] = id;
                    TurnoElegido.Text = "Turno #" + id;
                    NuevoInicio.Text = ((DateTime)clave.Values["Inicio"]).ToString("yyyy-MM-ddTHH:mm:ss");
                    NuevoFin.Text = ((DateTime)clave.Values["Fin"]).ToString("yyyy-MM-ddTHH:mm:ss");
                    Edicion.Visible = true;
                    break;
                case "CancelarTurno":
                    Guardar(() => dominio.Cancelar(id), "Turno cancelado.");
                    break;
                case "EliminarTurno":
                    Guardar(() => dominio.Eliminar(id), "Turno eliminado.");
                    break;
            }
        }
    }
}
