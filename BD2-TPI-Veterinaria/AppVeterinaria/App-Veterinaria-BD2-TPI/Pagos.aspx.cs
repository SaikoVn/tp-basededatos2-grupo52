using System;

namespace VeterinariaWeb
{
    public partial class PaginaPagos : PaginaClinica
    {
        private readonly Dominio.Pagos dominio = new Dominio.Pagos();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(Cargar);
        }

        private void Cargar()
        {
            DateTime? desde = FechaOpcional(DesdeLista);
            DateTime? hasta = FechaOpcional(HastaLista);
            if (desde.HasValue && hasta.HasValue && desde.Value.Date > hasta.Value.Date)
                throw new ArgumentException("La fecha desde debe ser anterior o igual a la fecha hasta.");
            Vincular(Tabla, dominio.Listar(IdOpcional(FiltroId), IdOpcional(FiltroTurno),
                Texto(FiltroComprobante, false), FiltroMetodo.SelectedValue, desde, hasta));
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }

    }
}
