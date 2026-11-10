<%@ Page Language="C#" Title="Reporte de turnos por profesional" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Reporte.aspx.cs" Inherits="VeterinariaWeb.PaginaReporte" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<section class="panel"><h2>Consultar turnos</h2><div class="campos"><label>Profesional<asp:DropDownList ID="Profesional" runat="server" CssClass="form-select" /></label>
<label>Desde<asp:TextBox ID="Desde" runat="server" CssClass="form-control" TextMode="Date" /></label>
<label>Hasta (inclusive)<asp:TextBox ID="Hasta" runat="server" CssClass="form-control" TextMode="Date" /></label>
<asp:Button ID="Consultar" runat="server" Text="Consultar" OnClick="Consultar_Click" CssClass="btn btn-primary" /></div></section>
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
