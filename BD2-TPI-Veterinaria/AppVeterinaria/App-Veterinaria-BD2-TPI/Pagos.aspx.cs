using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaPagos : PaginaClinica
    {
        private readonly Dominio.Pagos dominio = new Dominio.Pagos();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() => {
                Opciones(Turno, dominio.OpcionesTurnos());
                Cargar();
            });
        }

        private void Cargar()
        {
            var datos = dominio.Listar();
            Tabla.DataSource = datos;
            Tabla.DataBind();
        }

        protected void Registrar_Click(object sender, EventArgs e)
        {
            Guardar(() => {
                decimal monto;
                if (!decimal.TryParse(Monto.Text, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out monto) || monto <= 0 || monto > 99999999.99m || decimal.Round(monto, 2) != monto)
                    throw new ArgumentException("Ingresá un monto positivo con hasta dos decimales.");
                dominio.RegistrarPago(Id(Turno), Texto(Comprobante), monto, Metodo.SelectedValue);
            }, "Pago registrado. Verificá el estado del turno en la tabla.");
        }
    }
}
