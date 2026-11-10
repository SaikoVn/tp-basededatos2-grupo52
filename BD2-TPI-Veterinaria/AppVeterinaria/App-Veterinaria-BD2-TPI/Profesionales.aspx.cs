using System;
using System.Data;
using System.Globalization;
using System.Linq;
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
            Intentar(() => {
                Cargar();
            });
        }

        private void Cargar()
        {
            var datos = dominio.Listar();
            Tabla.DataSource = datos;
            Tabla.DataBind();
        }

        protected void Tabla_Comando(object sender, GridViewCommandEventArgs e)
        {
            var fila = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            var clave = Tabla.DataKeys[fila.RowIndex];
            int id = (int)clave.Values["ID"];
            Guardar(() => dominio.EstadoProfesional(id, e.CommandName == "Activar"), "Estado actualizado.");
        }
    }
}
