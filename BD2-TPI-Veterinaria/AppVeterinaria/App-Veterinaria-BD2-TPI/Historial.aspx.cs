using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaHistorial : PaginaClinica
    {
        private readonly Dominio.Historial dominio = new Dominio.Historial();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() => {
                Cargar();
            });
        }

        private void Cargar()
        {
            int mascota;
            int.TryParse(Request.QueryString["id"], out mascota);
            var datos = dominio.Listar(mascota);
            Tabla.DataSource = datos;
            Tabla.DataBind();
        }

        
    }
}
