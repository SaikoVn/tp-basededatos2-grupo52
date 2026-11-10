<%@ Page Language="C#" Title="Dueños" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Duenios.aspx.cs" Inherits="VeterinariaWeb.PaginaDuenios" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<section class="panel"><h2>Búsqueda</h2><div class="campos"><label>Nombre<asp:TextBox ID="Buscar" runat="server" CssClass="form-control"  /></label>
<asp:Button ID="Filtrar" runat="server" Text="Buscar" OnClick="Filtrar_Click" CssClass="btn btn-primary" /></div></section>
<section class="panel"><h2>Registrar dueño</h2><div class="campos"><label>DNI<asp:TextBox ID="Dni" runat="server" CssClass="form-control" MaxLength="15" /></label>
<label>Nombre<asp:TextBox ID="Nombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
<label>Apellido<asp:TextBox ID="Apellido" runat="server" CssClass="form-control" MaxLength="60" /></label>
<label>Teléfono (opcional)<asp:TextBox ID="Telefono" runat="server" CssClass="form-control" MaxLength="30" /></label>
<label>Correo (opcional)<asp:TextBox ID="Correo" runat="server" CssClass="form-control" MaxLength="100" /></label>
<label>Dirección (opcional)<asp:TextBox ID="Direccion" runat="server" CssClass="form-control" MaxLength="150" /></label>
<asp:Button ID="Crear" runat="server" Text="Registrar dueño" OnClick="Crear_Click" CssClass="btn btn-primary" /></div></section>
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
