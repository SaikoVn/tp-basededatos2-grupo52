using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaInicio : PaginaClinica
    {
        private readonly Dominio.Inicio dominio = new Dominio.Inicio();

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
            Indicadores.DataSource = datos.Columns.Cast<DataColumn>().Select(c => new { Etiqueta = c.ColumnName, Cantidad = datos.Rows[0][c] });
            Indicadores.DataBind();
        }

        
    }
}
