using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaProfesionales : PaginaClinica
    {
        private readonly Dominio.Profesionales dominio = new Dominio.Profesionales();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() =>
            {
                Opciones(Especialidad, dominio.Especialidades());
                Cargar();
            });
        }

        private void Cargar()
        {
            Vincular(Tabla, dominio.Listar(Texto(FiltroMatricula, false),
                Texto(FiltroNombre, false), Texto(FiltroApellido, false),
                Texto(FiltroEspecialidad, false)));
        }

        protected void Crear_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                if (ViewState["ProfesionalEditando"] == null)
                {
                    int id = dominio.Crear(Id(Especialidad), Texto(Matricula), Texto(Nombre),
                        Texto(Apellido), Texto(Telefono, false), Texto(Correo, false));
                    Avisar("Profesional registrado. ID: " + id + ".", false);
                }
                else
                {
                    int id = (int)ViewState["ProfesionalEditando"];
                    dominio.Editar(id, Id(Especialidad), Texto(Matricula),
                        Texto(Nombre), Texto(Apellido), Texto(Telefono, false), Texto(Correo, false));
                    Avisar("Profesional actualizado. ID: " + id + ".", false);
                }
                LimpiarEdicion();
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
            if (e.CommandName == "Editar")
            {
                Intentar(() =>
                {
                    var datos = dominio.Obtener(id);
                    if (datos.Rows.Count == 0) throw new ArgumentException("El profesional ya no existe.");
                    var fila = datos.Rows[0];
                    ViewState["ProfesionalEditando"] = id;
                    Especialidad.SelectedValue = Convert.ToString(fila["EspecialidadId"]);
                    Matricula.Text = Convert.ToString(fila["Matricula"]);
                    Nombre.Text = Convert.ToString(fila["Nombre"]);
                    Apellido.Text = Convert.ToString(fila["Apellido"]);
                    Telefono.Text = Convert.ToString(fila["Telefono"]);
                    Correo.Text = Convert.ToString(fila["Correo"]);
                    TituloFormulario.Text = "Editar profesional";
                    Crear.Text = "Guardar cambios";
                    CancelarEdicion.Visible = true;
                });
                return;
            }
            bool activar = e.CommandName == "Activar";
            Intentar(() =>
            {
                dominio.CambiarEstado(id, activar);
                Avisar((activar ? "Profesional activado." : "Profesional desactivado.") + " ID: " + id + ".", false);
                Cargar();
            });
        }

        protected void CancelarEdicion_Click(object sender, EventArgs e)
        {
            LimpiarEdicion();
        }

        private void LimpiarEdicion()
        {
            ViewState.Remove("ProfesionalEditando");
            Especialidad.SelectedIndex = 0;
            Nombre.Text = Apellido.Text = Matricula.Text = Telefono.Text = Correo.Text = "";
            TituloFormulario.Text = "Registrar profesional";
            Crear.Text = "Guardar profesional";
            CancelarEdicion.Visible = false;
        }
    }
}
