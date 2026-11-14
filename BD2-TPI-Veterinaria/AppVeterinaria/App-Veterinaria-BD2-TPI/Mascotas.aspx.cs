using System;
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
            Intentar(() =>
            {
                Opciones(Duenio, dominio.OpcionesDuenios());
                Cargar();
            });
        }

        private void Cargar()
        {
            Vincular(Tabla, dominio.Listar(Texto(FiltroNombre, false),
                Texto(FiltroEspecie, false), Texto(FiltroRaza, false),
                Texto(FiltroDuenio, false), EstadoLista.SelectedValue));
        }

        protected void Crear_Click(object sender, EventArgs e)
        {
            Intentar(() =>
            {
                if (ViewState["MascotaEditando"] == null)
                {
                    int id = dominio.Crear(Id(Duenio), Texto(Nombre), Texto(Especie),
                        Texto(Raza, false), FechaOpcional(Nacimiento),
                        string.IsNullOrEmpty(Sexo.SelectedValue) ? null : Sexo.SelectedValue);
                    Avisar("Mascota registrada. ID: " + id + ".", false);
                }
                else
                {
                    int id = (int)ViewState["MascotaEditando"];
                    dominio.Editar(id, Id(Duenio), Texto(Nombre), Texto(Especie),
                        Texto(Raza, false), FechaOpcional(Nacimiento),
                        string.IsNullOrEmpty(Sexo.SelectedValue) ? null : Sexo.SelectedValue);
                    Avisar("Mascota actualizada. ID: " + id + ".", false);
                }
                LimpiarEdicion();
                Cargar();
            });
        }

        protected void Filtrar_Click(object sender, EventArgs e)
        {
            Intentar(Cargar);
        }

        protected void Tabla_Comando(object sender, GridViewCommandEventArgs e)
        {
            int id;
            if (!int.TryParse(Convert.ToString(e.CommandArgument), out id)) return;
            if (e.CommandName == "Editar")
            {
                Intentar(() =>
                {
                    var datos = dominio.Obtener(id);
                    if (datos.Rows.Count == 0) throw new ArgumentException("La mascota ya no existe.");
                    var fila = datos.Rows[0];
                    ViewState["MascotaEditando"] = id;
                    Duenio.SelectedValue = Convert.ToString(fila["DuenioId"]);
                    Nombre.Text = Convert.ToString(fila["Nombre"]);
                    Especie.Text = Convert.ToString(fila["Especie"]);
                    Raza.Text = Convert.ToString(fila["Raza"]);
                    Nacimiento.Text = fila["Nacimiento"] == DBNull.Value
                        ? "" : ((DateTime)fila["Nacimiento"]).ToString("yyyy-MM-dd");
                    Sexo.SelectedValue = fila["Sexo"] == DBNull.Value ? "" : Convert.ToString(fila["Sexo"]);
                    TituloFormulario.Text = "Editar mascota";
                    Crear.Text = "Guardar cambios";
                    CancelarEdicion.Visible = true;
                });
                return;
            }
            bool activar = e.CommandName == "Reactivar";
            Intentar(() =>
            {
                dominio.CambiarEstado(id, activar);
                Avisar((activar ? "Mascota reactivada." : "Mascota dada de baja.") + " ID: " + id + ".", false);
                Cargar();
            });
        }

        protected void CancelarEdicion_Click(object sender, EventArgs e)
        {
            LimpiarEdicion();
        }

        private void LimpiarEdicion()
        {
            ViewState.Remove("MascotaEditando");
            Duenio.SelectedIndex = 0;
            Nombre.Text = Especie.Text = Raza.Text = Nacimiento.Text = "";
            Sexo.SelectedIndex = 0;
            TituloFormulario.Text = "Registrar mascota";
            Crear.Text = "Guardar mascota";
            CancelarEdicion.Visible = false;
        }
    }
}
