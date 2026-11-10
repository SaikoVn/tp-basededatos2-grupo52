using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    public partial class PaginaMascotas : PaginaClinica
    {
        private readonly Dominio.Mascotas dominio = new Dominio.Mascotas();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack) return;
            Intentar(() => {
                Opciones(Duenio, dominio.OpcionesDuenios());
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
            Guardar(() => dominio.CrearMascota(Id(Duenio), Texto(Nombre), Texto(Especie), Texto(Raza, false), Nacimiento.Text == "" ? (DateTime?)null : Fecha(Nacimiento), Sexo.SelectedValue == "" ? null : Sexo.SelectedValue), "Mascota registrada.");
        }
        
        protected void Tabla_Comando(object sender, GridViewCommandEventArgs e)
        {
            var fila = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            var clave = Tabla.DataKeys[fila.RowIndex];
            int id = (int)clave.Values["ID"];
            Guardar(() => dominio.BajaMascota(id), "Mascota inactiva.");
        }
    }
}
