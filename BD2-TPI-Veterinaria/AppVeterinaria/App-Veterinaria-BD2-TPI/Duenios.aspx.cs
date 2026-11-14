using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaDuenios : PaginaClinica
    {
        private readonly Dominio.Duenios dominio = new Dominio.Duenios();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Intentar(Cargar);
        }

        private void Cargar()
        {
            Vincular(Tabla, dominio.Listar(
                Texto(FiltroDni, false), Texto(FiltroNombre, false), Texto(FiltroApellido, false)));
        }

        protected void Crear_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                if (ViewState["DuenioEditando"] == null)
                {
                    int id = dominio.Crear(Texto(Dni), Texto(Nombre), Texto(Apellido),
                        Texto(Telefono, false), Texto(Correo, false), Texto(Direccion, false));
                    Avisar("Dueño registrado. ID: " + id + ".", false);
                }
                else
                {
                    int id = (int)ViewState["DuenioEditando"];
                    dominio.Editar(id, Texto(Dni), Texto(Nombre), Texto(Apellido),
                        Texto(Telefono, false), Texto(Correo, false), Texto(Direccion, false));
                    Avisar("Dueño actualizado. ID: " + id + ".", false);
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
                if (datos.Rows.Count == 0) throw new ArgumentException("El dueño ya no existe.");
                DataRow fila = datos.Rows[0];
                ViewState["DuenioEditando"] = id;
                Dni.Text = Convert.ToString(fila["DNI"]);
                Nombre.Text = Convert.ToString(fila["Nombre"]);
                Apellido.Text = Convert.ToString(fila["Apellido"]);
                Telefono.Text = Convert.ToString(fila["Telefono"]);
                Correo.Text = Convert.ToString(fila["Correo"]);
                Direccion.Text = Convert.ToString(fila["Direccion"]);
                TituloFormulario.Text = "Editar dueño";
                Crear.Text = "Guardar cambios";
                CancelarEdicion.Visible = true;
            });
        }

        protected void CancelarEdicion_Click(object sender, EventArgs e)
        {
            LimpiarEdicion();
        }

        private void LimpiarEdicion()
        {
            ViewState.Remove("DuenioEditando");
            Dni.Text = Nombre.Text = Apellido.Text = Telefono.Text = Correo.Text = Direccion.Text = "";
            TituloFormulario.Text = "Registrar dueño";
            Crear.Text = "Guardar dueño";
            CancelarEdicion.Visible = false;
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }
    }
}
