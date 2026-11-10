<%@ Page Language="C#" Title="Mascotas" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Mascotas.aspx.cs" Inherits="VeterinariaWeb.PaginaMascotas" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<section class="panel"><h2>Búsqueda</h2><div class="campos"><label>Nombre<asp:TextBox ID="Buscar" runat="server" CssClass="form-control"  /></label>
<asp:Button ID="Filtrar" runat="server" Text="Buscar" OnClick="Filtrar_Click" CssClass="btn btn-primary" /></div></section>
<section class="panel"><h2>Registrar mascota</h2><div class="campos"><label>Dueño<asp:DropDownList ID="Duenio" runat="server" CssClass="form-select" /></label>
<label>Nombre<asp:TextBox ID="Nombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
<label>Especie<asp:TextBox ID="Especie" runat="server" CssClass="form-control" MaxLength="40" /></label>
<label>Raza (opcional)<asp:TextBox ID="Raza" runat="server" CssClass="form-control" MaxLength="60" /></label>
<label>Nacimiento (opcional)<asp:TextBox ID="Nacimiento" runat="server" CssClass="form-control" TextMode="Date" /></label>
<label>Sexo<asp:DropDownList ID="Sexo" runat="server" CssClass="form-select"><asp:ListItem Value="">Sin informar</asp:ListItem><asp:ListItem Value="M">Macho</asp:ListItem><asp:ListItem Value="F">Hembra</asp:ListItem></asp:DropDownList></label>
<asp:Button ID="Crear" runat="server" Text="Registrar mascota" OnClick="Crear_Click" CssClass="btn btn-primary" /></div></section>
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta." DataKeyNames="ID" OnRowCommand="Tabla_Comando" OnRowDataBound="FormatearFila"><Columns><asp:TemplateField HeaderText="Acciones"><ItemTemplate><asp:HyperLink runat="server" Text="Historial" NavigateUrl='<%# "Historial.aspx?id=" + Eval("ID") %>'/> <asp:Button runat="server" Text="Dar de baja" CommandName="Baja" CssClass="btn btn-sm btn-outline-secondary" Visible='<%# (bool)Eval("Estado") %>'/></ItemTemplate></asp:TemplateField></Columns></asp:GridView></div>
</asp:Content>
