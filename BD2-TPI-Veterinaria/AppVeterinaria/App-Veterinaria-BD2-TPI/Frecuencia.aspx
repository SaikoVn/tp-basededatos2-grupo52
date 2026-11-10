<%@ Page Language="C#" Title="Frecuencia de consultas" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Frecuencia.aspx.cs" Inherits="VeterinariaWeb.PaginaFrecuencia" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
