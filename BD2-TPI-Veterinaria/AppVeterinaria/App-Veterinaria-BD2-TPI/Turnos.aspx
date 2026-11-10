<%@ Page Language="C#" Title="Turnos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Turnos.aspx.cs" Inherits="VeterinariaWeb.PaginaTurnos" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<section class="panel"><h2>Registrar turno</h2><div class="campos"><label>Mascota activa<asp:DropDownList ID="Mascota" runat="server" CssClass="form-select" /></label>
<label>Profesional activo<asp:DropDownList ID="Profesional" runat="server" CssClass="form-select" /></label>
<label>Inicio<asp:TextBox ID="Inicio" runat="server" CssClass="form-control" TextMode="DateTimeLocal" /></label>
<label>Fin<asp:TextBox ID="Fin" runat="server" CssClass="form-control" TextMode="DateTimeLocal" /></label>
<label>Motivo (opcional)<asp:TextBox ID="Motivo" runat="server" CssClass="form-control" MaxLength="200" /></label>
<asp:Button ID="Crear" runat="server" Text="Registrar turno" OnClick="Crear_Click" CssClass="btn btn-primary" /></div></section>
<asp:Panel ID="Edicion" runat="server" Visible="false"><section class="panel"><h2>Reprogramar turno</h2><div class="campos"><asp:Label ID="TurnoElegido" runat="server"  />
<label>Inicio<asp:TextBox ID="NuevoInicio" runat="server" CssClass="form-control" TextMode="DateTimeLocal" step="1" /></label>
<label>Fin<asp:TextBox ID="NuevoFin" runat="server" CssClass="form-control" TextMode="DateTimeLocal" step="1" /></label>
<asp:Button ID="GuardarHorario" runat="server" Text="Guardar horario" OnClick="GuardarHorario_Click" CssClass="btn btn-primary" />
<asp:Button ID="Volver" runat="server" Text="Volver" OnClick="Volver_Click" CssClass="btn btn-primary" /></div></section>
</asp:Panel><div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta." DataKeyNames="ID,Inicio,Fin" OnRowCommand="Tabla_Comando" OnRowDataBound="FormatearFila"><Columns><asp:TemplateField HeaderText="Acciones"><ItemTemplate><asp:Button runat="server" Text="Reprogramar" CommandName="EditarHorario" CssClass="btn btn-sm btn-outline-secondary" Visible='<%# Eval("Estado").ToString() == "pendiente" %>'/>
<asp:Button runat="server" Text="Cancelar turno" CommandName="CancelarTurno" CssClass="btn btn-sm btn-outline-secondary" Visible='<%# Eval("Estado").ToString() == "pendiente" %>'/>
<asp:Button runat="server" Text="Eliminar" CommandName="EliminarTurno" CssClass="btn btn-sm btn-outline-secondary" OnClientClick="return confirm('¿Eliminar definitivamente este turno?');"/></ItemTemplate></asp:TemplateField></Columns></asp:GridView></div>
</asp:Content>
