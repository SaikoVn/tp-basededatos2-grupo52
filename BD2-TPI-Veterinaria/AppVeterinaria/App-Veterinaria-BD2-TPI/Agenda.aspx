<%@ Page Language="C#" Title="Agenda de turnos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Agenda.aspx.cs" Inherits="VeterinariaWeb.PaginaAgenda" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
