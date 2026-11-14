using System;
using System.Data;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaEspecialidades : PaginaClinica
    {
        private readonly Dominio.Especialidades dominio = new Dominio.Especialidades();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Intentar(Cargar);
        }

        private void Cargar()
        {
            Vincular(Tabla, dominio.Listar());
        }

        protected void Guardar_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                string nombre = Texto(Nombre);
                if (ViewState["EspecialidadEditando"] == null)
                {
                    int id = dominio.Crear(nombre);
                    Avisar("Especialidad agregada. ID: " + id + ".", false);
                }
                else
                {
                    int id = (int)ViewState["EspecialidadEditando"];
                    dominio.Editar(id, nombre);
                    Avisar("Especialidad actualizada. ID: " + id + ".", false);
                }
                LimpiarEdicion();
                Cargar();
            });
        }

        protected void Tabla_Comando(object sender, GridViewCommandEventArgs e)
        {
            int id;
            if (e.CommandName != "Editar" || !int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            Intentar(() =>
            {
                DataTable datos = dominio.Obtener(id);
                if (datos.Rows.Count == 0) throw new ArgumentException("La especialidad ya no existe.");
                ViewState["EspecialidadEditando"] = id;
                Nombre.Text = Convert.ToString(datos.Rows[0]["Nombre"]);
                TituloFormulario.Text = "Editar especialidad";
                Guardar.Text = "Guardar cambios";
                Cancelar.Visible = true;
            });
        }

        protected void Cancelar_Click(object sender, EventArgs e)
        {
            LimpiarEdicion();
        }

        private void LimpiarEdicion()
        {
            ViewState.Remove("EspecialidadEditando");
            Nombre.Text = "";
            TituloFormulario.Text = "Agregar especialidad";
            Guardar.Text = "Guardar especialidad";
            Cancelar.Visible = false;
        }
    }
}
