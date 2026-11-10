using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaFrecuencia : PaginaClinica
    {
        private readonly Dominio.Frecuencia dominio = new Dominio.Frecuencia();

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

        
    }
}
