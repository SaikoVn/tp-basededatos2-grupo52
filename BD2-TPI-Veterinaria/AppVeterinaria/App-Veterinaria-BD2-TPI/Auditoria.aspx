<%@ Page Language="C#" Title="Auditoría de turnos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Auditoria.aspx.cs" Inherits="VeterinariaWeb.PaginaAuditoria" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <p>Eventos registrados por los triggers de turnos.</p>
    <section class="panel">
        <h2>Filtrar auditoría</h2>
        <div class="campos">
            <label>ID de auditoría exacto<asp:TextBox ID="FiltroId" runat="server" CssClass="form-control" MaxLength="10" /></label>
            <label>ID de turno exacto<asp:TextBox ID="FiltroTurno" runat="server" CssClass="form-control" MaxLength="10" /></label>
            <label>Evento<asp:DropDownList ID="EventoLista" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Todos</asp:ListItem>
                <asp:ListItem Value="alta">Alta</asp:ListItem>
                <asp:ListItem Value="baja">Baja</asp:ListItem>
                <asp:ListItem Value="reprogramacion">Reprogramación</asp:ListItem>
                <asp:ListItem Value="cancelado">Cancelado</asp:ListItem>
            </asp:DropDownList></label>
            <label>Desde<asp:TextBox ID="DesdeLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Hasta inclusive<asp:TextBox ID="HastaLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Auditoria.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="No hay eventos que coincidan con esos filtros." />
        </div>
    </section>
</asp:Content>