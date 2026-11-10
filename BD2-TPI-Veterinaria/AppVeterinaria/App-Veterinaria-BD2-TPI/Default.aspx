<%@ Page Language="C#" Title="Inicio" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VeterinariaWeb.PaginaInicio" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
<asp:Repeater ID="Indicadores" runat="server" ><HeaderTemplate><div class="indicadores"></HeaderTemplate><ItemTemplate><div class="panel"><%#: Eval("Etiqueta") %><strong><%#: Eval("Cantidad") %></strong></div></ItemTemplate><FooterTemplate></div></FooterTemplate></asp:Repeater>
</asp:Content>
