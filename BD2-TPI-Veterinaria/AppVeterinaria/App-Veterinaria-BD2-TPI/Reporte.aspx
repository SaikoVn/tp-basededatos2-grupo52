<%@ Page Language="C#" Title="Reporte por profesional" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Reporte.aspx.cs" Inherits="VeterinariaWeb.PaginaReporte" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <section class="panel">
        <h2>Turnos entre dos fechas</h2>
        <p>Elegí un profesional y un período. La consulta se realiza con el procedimiento almacenado de reporte.</p>
        <div class="campos">
            <label>Profesional<asp:DropDownList ID="Profesional" runat="server" CssClass="form-select" /></label>
            <label>Desde<asp:TextBox ID="Desde" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Hasta (inclusive)<asp:TextBox ID="Hasta" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <asp:Button ID="Consultar" runat="server" Text="Consultar" OnClick="Consultar_Click" CssClass="btn btn-primary" />
        </div>
    </section>
    <section class="panel">
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="Ingresá un período para consultar." />
        </div>
    </section>
</asp:Content>