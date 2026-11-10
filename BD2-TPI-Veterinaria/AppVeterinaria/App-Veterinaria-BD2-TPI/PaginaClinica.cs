using System;
using System.Data;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.Data.SqlClient;

namespace VeterinariaWeb
{
    public class PaginaClinica : Page
    {
        protected override void OnInit(EventArgs e)
        {
            ViewStateUserKey = Session.SessionID;
            base.OnInit(e);
        }

        protected void Avisar(string mensaje, bool error)
        {
            var aviso = (Label)Master.FindControl("Aviso");
            aviso.Text = Server.HtmlEncode(mensaje);
            aviso.CssClass = error ? "alert alert-danger d-block" : "alert alert-success d-block";
            aviso.Visible = true;
        }

        protected void Intentar(Action operacion)
        {
            try { operacion(); }
            catch (ArgumentException e) { Avisar(e.Message, true); }
            catch (SqlException e)
            {
                foreach (SqlError detalle in e.Errors)
                    if (detalle.Number >= 50000) { Avisar(detalle.Message, true); return; }
                string mensaje = "No se pudo completar la operación. Revisá la conexión a Veterinaria y los permisos.";
                if (e.Number == 547) mensaje = e.Message.Contains("FK_Pagos_Turnos") || e.Message.Contains("FK_HistoriasClinicas_Turnos")
                    ? "El turno tiene pagos o historias clínicas asociados y no se puede eliminar."
                    : "Los datos no cumplen las restricciones de la base.";
                if (e.Number == 2627 || e.Number == 2601) mensaje = "Ya existe un registro con ese DNI, comprobante o turno.";
                Avisar(mensaje, true);
            }
        }

        protected void Guardar(Action operacion, string mensaje)
        {
            Intentar(() => {
                operacion();
                Session["Mensaje"] = mensaje;
                Response.Redirect(Request.Path, false);
                Context.ApplicationInstance.CompleteRequest();
            });
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            if (!IsPostBack && Session["Mensaje"] is string)
            {
                Avisar((string)Session["Mensaje"], false);
                Session.Remove("Mensaje");
            }
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
            if (obligatorio && valor.Length == 0) throw new ArgumentException("Completá los campos obligatorios.");
            if (campo.MaxLength > 0 && valor.Length > campo.MaxLength) throw new ArgumentException("El texto supera el máximo permitido.");
            return valor == "" ? null : valor;
        }

        protected void FormatearFila(object sender, GridViewRowEventArgs e)
        {
            var fila = e.Row.DataItem as DataRowView;
            if (fila == null) return;
            int inicio = e.Row.Cells.Count - fila.DataView.Table.Columns.Count;
            for (int i = 0; i < fila.DataView.Table.Columns.Count; i++)
            {
                var valor = fila[i];
                var celda = e.Row.Cells[inicio + i];
                if (valor is bool) celda.Text = (bool)valor ? "Activo" : "Inactivo";
                if (valor is decimal) celda.Text = ((decimal)valor).ToString("N2");
                if (valor is DateTime) celda.Text = ((DateTime)valor).ToString(
                    fila.DataView.Table.Columns[i].ColumnName == "Nacimiento" ? "dd/MM/yyyy" : "dd/MM/yyyy HH:mm:ss");
            }
        }
        protected static int Id(DropDownList lista)
        {
            int id;
            if (!int.TryParse(lista.SelectedValue, out id)) throw new ArgumentException("Seleccioná un registro.");
            return id;
        }

        protected static DateTime Fecha(TextBox campo)
        {
            DateTime fecha;
            if (!DateTime.TryParse(campo.Text, CultureInfo.InvariantCulture, DateTimeStyles.None, out fecha) || fecha.Year < 1753)
                throw new ArgumentException("Ingresá una fecha válida.");
            return fecha;
        }
    }
}

