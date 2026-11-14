using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace VeterinariaWeb
{
    // Ayudas compartidas para mostrar errores y cargar formularios.
    public class PaginaClinica : Page
    {
        protected void Intentar(Action accion)
        {
            try { accion(); }
            catch (ArgumentException error) { Avisar(error.Message, true); }
            catch (SqlException error)
            {
                string mensaje = error.Number >= 50000
                    ? error.Message
                    : "No se pudo completar la operación. Revisá los datos y la conexión.";
                Avisar(mensaje, true);
            }
        }

        protected void Avisar(string mensaje, bool error)
        {
            var aviso = Master.FindControl("Aviso") as Label;
            if (aviso == null) return;
            aviso.Text = Server.HtmlEncode(mensaje);
            aviso.CssClass = error ? "alert alert-danger d-block" : "alert alert-success d-block";
            aviso.Visible = true;
        }

        protected static void Vincular(GridView grilla, DataTable datos)
        {
            grilla.DataSource = datos;
            grilla.DataBind();
        }

        protected static void Opciones(DropDownList lista, DataTable datos)
        {
            lista.DataValueField = datos.Columns[0].ColumnName;
            lista.DataTextField = datos.Columns[1].ColumnName;
            lista.DataSource = datos;
            lista.DataBind();
            lista.Items.Insert(0, new ListItem("Seleccionar", ""));
        }

        protected static string Texto(TextBox campo, bool obligatorio = true)
        {
            string valor = campo.Text.Trim();
            if (obligatorio && valor.Length == 0)
                throw new ArgumentException("Completá el campo " + campo.ID + ".");
            if (campo.MaxLength > 0 && valor.Length > campo.MaxLength)
                throw new ArgumentException("El texto supera el máximo permitido.");
            return valor.Length == 0 ? null : valor;
        }

        protected static int Id(DropDownList lista)
        {
            int id;
            if (!int.TryParse(lista.SelectedValue, out id))
                throw new ArgumentException("Seleccioná una opción.");
            return id;
        }

        protected static int Id(TextBox campo)
        {
            int id;
            if (!int.TryParse(campo.Text, out id))
                throw new ArgumentException("Ingresá un número de registro válido.");
            return id;
        }

        protected static int IdOpcional(TextBox campo)
        {
            return string.IsNullOrWhiteSpace(campo.Text) ? 0 : Id(campo);
        }

        protected static DateTime Fecha(TextBox campo)
        {
            DateTime fecha;
            if (!DateTime.TryParse(campo.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, out fecha))
                throw new ArgumentException("Ingresá una fecha válida.");
            return fecha;
        }

        protected static DateTime? FechaOpcional(TextBox campo)
        {
            return string.IsNullOrWhiteSpace(campo.Text) ? (DateTime?)null : Fecha(campo);
        }
    }
}