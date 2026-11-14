<%@ Page Language="C#" Title="Agenda de turnos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Agenda.aspx.cs" Inherits="VeterinariaWeb.PaginaAgenda" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <p>Turnos de mascotas activas, leídos desde la vista de agenda.</p>
    <section class="panel">
        <h2>Filtrar agenda</h2>
        <div class="campos">
            <label>Mascota<asp:TextBox ID="FiltroMascota" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Profesional<asp:TextBox ID="FiltroProfesional" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <label>Estado<asp:DropDownList ID="EstadoLista" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Todos</asp:ListItem>
                <asp:ListItem Value="pendiente">Pendiente</asp:ListItem>
                <asp:ListItem Value="atendido">Atendido</asp:ListItem>
                <asp:ListItem Value="cancelado">Cancelado</asp:ListItem>
            </asp:DropDownList></label>
            <label>Desde<asp:TextBox ID="DesdeLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Hasta inclusive<asp:TextBox ID="HastaLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Agenda.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="No hay turnos que coincidan con esos filtros." />
        </div>
    </section>
</asp:Content>