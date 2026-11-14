using System;
using System.Web.UI;

namespace VeterinariaWeb
{
    public partial class PaginaFacturacion : PaginaClinica
    {
        private readonly Dominio.Facturacion dominio = new Dominio.Facturacion();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Intentar(Cargar);
        }

        private void Cargar()
        {
            Vincular(Tabla, dominio.Listar(
                Texto(FiltroMatricula, false), Texto(FiltroProfesional, false)));
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }
    }
}