<%@ Page Language="C#" Title="Historial clínico" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Historial.aspx.cs" Inherits="VeterinariaWeb.PaginaHistorial" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
