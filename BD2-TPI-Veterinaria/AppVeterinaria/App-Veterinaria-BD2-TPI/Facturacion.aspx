<%@ Page Language="C#" Title="Facturación" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Facturacion.aspx.cs" Inherits="VeterinariaWeb.PaginaFacturacion" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <p>Resumen de pagos por profesional, leído desde la vista de facturación.</p>
    <section class="panel">
        <h2>Filtrar facturación</h2>
        <div class="campos">
            <label>Matrícula exacta<asp:TextBox ID="FiltroMatricula" runat="server" CssClass="form-control" MaxLength="20" /></label>
            <label>Profesional<asp:TextBox ID="FiltroProfesional" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Facturacion.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="No hay profesionales que coincidan con esos filtros." />
        </div>
    </section>
</asp:Content>