using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaDuenios : PaginaClinica
    {
        private readonly Dominio.Duenios dominio = new Dominio.Duenios();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() => {
                Cargar();
            });
        }

        private void Cargar()
        {
            var datos = dominio.Listar(Buscar.Text.Trim());
            Tabla.DataSource = datos;
            Tabla.DataBind();
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }
        
        protected void Crear_Click(object sender, EventArgs e)
        {
            Guardar(() => dominio.CrearDuenio(Texto(Dni), Texto(Nombre), Texto(Apellido), Texto(Telefono, false), Texto(Correo, false), Texto(Direccion, false)), "Dueño registrado.");
        }
    }
}
