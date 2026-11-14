using System;
using System.Web.UI;

namespace VeterinariaWeb
{
    public partial class PaginaReporte : PaginaClinica
    {
        private readonly Dominio.Reporte dominio = new Dominio.Reporte();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Intentar(() => Opciones(Profesional, dominio.OpcionesProfesionales()));
        }

        protected void Consultar_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                DateTime desde = Fecha(Desde).Date;
                DateTime hasta = Fecha(Hasta).Date;
                if (desde > hasta)
                    throw new ArgumentException("La fecha desde debe ser anterior o igual a la fecha hasta.");

                Vincular(Tabla, dominio.Consultar(Id(Profesional), desde, hasta));
                Avisar("Reporte consultado.", false);
            });
        }
    }
}