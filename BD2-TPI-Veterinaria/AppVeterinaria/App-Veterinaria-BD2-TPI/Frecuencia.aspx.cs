using System;
using System.Web.UI;

namespace VeterinariaWeb
{
    public partial class PaginaFrecuencia : PaginaClinica
    {
        private readonly Dominio.Frecuencia dominio = new Dominio.Frecuencia();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Intentar(Cargar);
        }

        private void Cargar()
        {
            Vincular(Tabla, dominio.Listar(Texto(FiltroMascota, false),
                Texto(FiltroEspecie, false), Texto(FiltroDni, false), EstadoLista.SelectedValue));
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }
    }
}