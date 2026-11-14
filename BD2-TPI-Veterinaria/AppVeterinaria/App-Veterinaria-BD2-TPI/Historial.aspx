<%@ Page Language="C#" Title="Historial clínico" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Historial.aspx.cs" Inherits="VeterinariaWeb.PaginaHistorial" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <p>Historial clínico leído desde la vista correspondiente. Incluye mascotas dadas de baja.</p>
    <section class="panel">
        <h2>Filtrar historial</h2>
        <div class="campos">
            <label>Mascota<asp:TextBox ID="FiltroMascota" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Dueño<asp:TextBox ID="FiltroDuenio" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <label>ID de turno exacto<asp:TextBox ID="FiltroTurno" runat="server" CssClass="form-control" MaxLength="10" /></label>
            <label>Desde<asp:TextBox ID="DesdeLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Hasta inclusive<asp:TextBox ID="HastaLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Historial.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="No hay atenciones que coincidan con esos filtros." />
        </div>
    </section>
</asp:Content>