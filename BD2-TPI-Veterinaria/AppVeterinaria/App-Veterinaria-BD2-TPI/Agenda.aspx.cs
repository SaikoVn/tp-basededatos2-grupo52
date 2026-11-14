using System;
using System.Web.UI;

namespace VeterinariaWeb
{
    public partial class PaginaAgenda : PaginaClinica
    {
        private readonly Dominio.Agenda dominio = new Dominio.Agenda();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) Intentar(Cargar);
        }

        private void Cargar()
        {
            DateTime? desde = FechaOpcional(DesdeLista);
            DateTime? hasta = FechaOpcional(HastaLista);
            if (desde.HasValue && hasta.HasValue && desde.Value.Date > hasta.Value.Date)
                throw new ArgumentException("La fecha desde debe ser anterior o igual a la fecha hasta.");
            Vincular(Tabla, dominio.Listar(Texto(FiltroMascota, false),
                Texto(FiltroProfesional, false), EstadoLista.SelectedValue, desde, hasta));
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }
    }
}