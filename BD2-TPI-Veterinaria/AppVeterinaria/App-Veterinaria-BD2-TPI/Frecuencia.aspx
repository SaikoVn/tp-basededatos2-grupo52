<%@ Page Language="C#" Title="Frecuencia de consultas" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Frecuencia.aspx.cs" Inherits="VeterinariaWeb.PaginaFrecuencia" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <p>Cantidad de turnos atendidos por mascota, leída desde la vista de frecuencia.</p>
    <section class="panel">
        <h2>Filtrar frecuencia</h2>
        <div class="campos">
            <label>Mascota<asp:TextBox ID="FiltroMascota" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Especie<asp:TextBox ID="FiltroEspecie" runat="server" CssClass="form-control" MaxLength="40" /></label>
            <label>DNI del dueño exacto<asp:TextBox ID="FiltroDni" runat="server" CssClass="form-control" MaxLength="15" /></label>
            <label>Estado<asp:DropDownList ID="EstadoLista" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Todos</asp:ListItem>
                <asp:ListItem Value="1">Activas</asp:ListItem>
                <asp:ListItem Value="0">Inactivas</asp:ListItem>
            </asp:DropDownList></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Frecuencia.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="No hay mascotas que coincidan con esos filtros." />
        </div>
    </section>
</asp:Content>