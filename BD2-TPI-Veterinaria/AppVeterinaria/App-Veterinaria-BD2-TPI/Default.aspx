<%@ Page Language="C#" Title="Inicio" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VeterinariaWeb.PaginaInicio" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <section class="panel">
        <h2>Administración de la clínica</h2>
        <p>Desde el menú podés registrar dueños, mascotas, profesionales y turnos, y consultar los reportes de la base de datos.</p>
        <p>La agenda, el historial, la facturación y la frecuencia de consultas se muestran desde vistas. El reporte por profesional ejecuta un procedimiento almacenado.</p>
        <p><a href="Turnos.aspx">Registrar o modificar turnos</a> ·
           <a href="Pagos.aspx">Registrar un pago</a> ·
           <a href="Reporte.aspx">Abrir reporte por profesional</a></p>
    </section>
</asp:Content>