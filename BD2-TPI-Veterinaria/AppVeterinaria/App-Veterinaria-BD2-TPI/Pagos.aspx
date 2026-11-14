<%@ Page Language="C#" Title="Pagos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Pagos.aspx.cs" Inherits="VeterinariaWeb.PaginaPagos" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <p class="text-muted">Los pagos se registran junto con la atención desde Turnos.</p>
    <section class="panel">
        <h2>Filtrar pagos</h2>
        <div class="campos">
            <label>ID de pago exacto<asp:TextBox ID="FiltroId" runat="server" CssClass="form-control" MaxLength="10" /></label>
            <label>ID de turno exacto<asp:TextBox ID="FiltroTurno" runat="server" CssClass="form-control" MaxLength="10" /></label>
            <label>Comprobante exacto<asp:TextBox ID="FiltroComprobante" runat="server" CssClass="form-control" MaxLength="20" /></label>
            <label>Método<asp:DropDownList ID="FiltroMetodo" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Todos</asp:ListItem>
                <asp:ListItem Value="efectivo">Efectivo</asp:ListItem>
                <asp:ListItem Value="tarjeta">Tarjeta</asp:ListItem>
                <asp:ListItem Value="transferencia">Transferencia</asp:ListItem>
            </asp:DropDownList></label>
            <label>Desde<asp:TextBox ID="DesdeLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Hasta inclusive<asp:TextBox ID="HastaLista" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Pagos.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <h2>Pagos registrados</h2>
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" EmptyDataText="No hay pagos que coincidan con esos filtros." />
        </div>
    </section>
</asp:Content>
