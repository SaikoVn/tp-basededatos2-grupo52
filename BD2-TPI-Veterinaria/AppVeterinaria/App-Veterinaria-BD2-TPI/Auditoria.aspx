<%@ Page Language="C#" Title="Auditoría de turnos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Auditoria.aspx.cs" Inherits="VeterinariaWeb.PaginaAuditoria" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
