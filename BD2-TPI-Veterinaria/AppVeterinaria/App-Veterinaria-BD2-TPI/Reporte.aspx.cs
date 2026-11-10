using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaReporte : PaginaClinica
    {
        private readonly Dominio.Reporte dominio = new Dominio.Reporte();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() => {
                Opciones(Profesional, dominio.OpcionesProfesionales());
            });
        }

        private void Cargar()
        {
            var desde = Fecha(Desde);
            var hasta = Fecha(Hasta);
            if (desde > hasta || hasta == DateTime.MaxValue.Date) throw new ArgumentException("Revisá el rango de fechas.");
            Tabla.DataSource = dominio.Consultar(Id(Profesional), desde, hasta);
            Tabla.DataBind();
        }

        protected void Consultar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }
    }
}
