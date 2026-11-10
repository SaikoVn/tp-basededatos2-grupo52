<%@ Page Language="C#" Title="Pagos" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Pagos.aspx.cs" Inherits="VeterinariaWeb.PaginaPagos" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<section class="panel"><h2>Registrar pago</h2><div class="campos"><label>Turno<asp:DropDownList ID="Turno" runat="server" CssClass="form-select" /></label>
<label>Número de comprobante<asp:TextBox ID="Comprobante" runat="server" CssClass="form-control" MaxLength="20" /></label>
<label>Monto<asp:TextBox ID="Monto" runat="server" CssClass="form-control" TextMode="Number" step="0.01" min="0.01" /></label>
<label>Método<asp:DropDownList ID="Metodo" runat="server" CssClass="form-select"><asp:ListItem Value="efectivo">Efectivo</asp:ListItem><asp:ListItem Value="tarjeta">Tarjeta</asp:ListItem><asp:ListItem Value="transferencia">Transferencia</asp:ListItem></asp:DropDownList></label>
<asp:Button ID="Registrar" runat="server" Text="Registrar pago" OnClick="Registrar_Click" CssClass="btn btn-primary" /></div></section>
<div class="table-responsive"><asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None" EmptyDataText="Sin registros para esta consulta."  OnRowDataBound="FormatearFila"></asp:GridView></div>
</asp:Content>
