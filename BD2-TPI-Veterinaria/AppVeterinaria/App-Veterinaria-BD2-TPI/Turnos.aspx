<%@ Page Language="C#" Title="Turnos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Turnos.aspx.cs" Inherits="VeterinariaWeb.PaginaTurnos" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <section class="panel">
        <h2>Registrar turno</h2>
        <div class="campos">
            <label>Mascota activa<asp:DropDownList ID="Mascota" runat="server" CssClass="form-select" /></label>
            <label>Profesional activo<asp:DropDownList ID="Profesional" runat="server" CssClass="form-select" /></label>
            <label>Inicio<asp:TextBox ID="Inicio" runat="server" CssClass="form-control" TextMode="DateTimeLocal" /></label>
            <label>Fin<asp:TextBox ID="Fin" runat="server" CssClass="form-control" TextMode="DateTimeLocal" /></label>
            <label>Motivo (opcional)<asp:TextBox ID="Motivo" runat="server" CssClass="form-control" MaxLength="200" /></label>
            <asp:Button ID="Crear" runat="server" Text="Guardar turno" OnClick="Crear_Click" CssClass="btn btn-primary" />
        </div>
    </section>
    <asp:Panel ID="Edicion" runat="server" Visible="false" CssClass="panel">
        <h2>Reprogramar turno</h2>
        <div class="campos">
            <label>Profesional<asp:DropDownList ID="NuevoProfesional" runat="server" CssClass="form-select" /></label>
            <label>Inicio<asp:TextBox ID="NuevoInicio" runat="server" CssClass="form-control" TextMode="DateTimeLocal" /></label>
            <label>Fin<asp:TextBox ID="NuevoFin" runat="server" CssClass="form-control" TextMode="DateTimeLocal" /></label>
            <label>Motivo (opcional)<asp:TextBox ID="NuevoMotivo" runat="server" CssClass="form-control" MaxLength="200" /></label>
            <asp:Button ID="GuardarHorario" runat="server" Text="Guardar cambios" OnClick="GuardarHorario_Click" CssClass="btn btn-primary" />
            <asp:Button ID="Volver" runat="server" Text="Cancelar edición" OnClick="Volver_Click" CssClass="btn btn-outline-secondary" />
        </div>
    </asp:Panel>
    <asp:Panel ID="Atencion" runat="server" Visible="false" CssClass="panel">
        <h2>Registrar atención</h2>
        <p>Turno <asp:Label ID="TurnoAtencion" runat="server" />. Al guardar, se crea la ficha clínica y el turno queda atendido.</p>
        <div class="campos">
            <label>Diagnóstico<asp:TextBox ID="Diagnostico" runat="server" CssClass="form-control" MaxLength="300" TextMode="MultiLine" /></label>
            <label>Tratamiento (opcional)<asp:TextBox ID="Tratamiento" runat="server" CssClass="form-control" MaxLength="300" TextMode="MultiLine" /></label>
            <label>Observaciones (opcional)<asp:TextBox ID="Observaciones" runat="server" CssClass="form-control" MaxLength="1000" TextMode="MultiLine" /></label>
            <label>Número de comprobante<asp:TextBox ID="ComprobanteAtencion" runat="server" CssClass="form-control" MaxLength="20" /></label>
            <label>Monto<asp:TextBox ID="MontoAtencion" runat="server" CssClass="form-control" TextMode="Number" step="0.01" min="0.01" /></label>
            <label>Método de pago<asp:DropDownList ID="MetodoAtencion" runat="server" CssClass="form-select">
                <asp:ListItem Value="efectivo">Efectivo</asp:ListItem>
                <asp:ListItem Value="tarjeta">Tarjeta</asp:ListItem>
                <asp:ListItem Value="transferencia">Transferencia</asp:ListItem>
            </asp:DropDownList></label>
            <asp:Button ID="GuardarAtencion" runat="server" Text="Guardar atención" OnClick="GuardarAtencion_Click" CssClass="btn btn-primary" />
            <asp:Button ID="CancelarAtencion" runat="server" Text="Volver al listado" OnClick="CancelarAtencion_Click" CssClass="btn btn-outline-secondary" />
        </div>
    </asp:Panel>
    <section class="panel">
        <h2>Filtrar turnos</h2>
        <div class="campos">
            <label>ID exacto<asp:TextBox ID="FiltroId" runat="server" CssClass="form-control" MaxLength="10" /></label>
            <label>Mascota<asp:TextBox ID="FiltroMascota" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Profesional<asp:TextBox ID="FiltroProfesional" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <label>Estado<asp:DropDownList ID="FiltroEstado" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Todos</asp:ListItem>
                <asp:ListItem Value="pendiente">Pendiente</asp:ListItem>
                <asp:ListItem Value="atendido">Atendido</asp:ListItem>
                <asp:ListItem Value="cancelado">Cancelado</asp:ListItem>
            </asp:DropDownList></label>
            <label>Desde<asp:TextBox ID="DesdeLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Hasta inclusive<asp:TextBox ID="HastaLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Turnos.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <h2>Turnos registrados</h2>
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="false" OnRowCommand="Tabla_Comando" EmptyDataText="No hay turnos que coincidan con esos filtros.">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="Turno" />
                    <asp:BoundField DataField="Mascota" HeaderText="Mascota" />
                    <asp:BoundField DataField="Profesional" HeaderText="Profesional" />
                    <asp:BoundField DataField="Inicio" HeaderText="Inicio" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    <asp:BoundField DataField="Fin" HeaderText="Fin" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    <asp:BoundField DataField="Estado" HeaderText="Estado" />
                    <asp:BoundField DataField="Motivo" HeaderText="Motivo" />
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="Registrar atención" CommandName="Atender"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-primary"
                                Visible='<%# Convert.ToBoolean(Eval("PuedeAtender")) &amp;&amp; Eval("Estado").ToString() == "pendiente" %>' />
                            <asp:Button runat="server" Text="Reprogramar" CommandName="Editar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# Eval("Estado").ToString() == "pendiente" %>' />
                            <asp:Button runat="server" Text="Cancelar" CommandName="Cancelar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# Eval("Estado").ToString() == "pendiente" %>' />
                            <asp:Button runat="server" Text="Eliminar" CommandName="Eliminar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# Eval("Estado").ToString() == "cancelado" %>'
                                OnClientClick="return confirm('¿Eliminar este turno?');" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
