<%@ Page Language="C#" Title="Especialidades" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Especialidades.aspx.cs" Inherits="VeterinariaWeb.PaginaEspecialidades" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <asp:Panel ID="Formulario" runat="server" CssClass="panel">
        <h2><asp:Label ID="TituloFormulario" runat="server" Text="Agregar especialidad" /></h2>
        <div class="campos">
            <label>Nombre<asp:TextBox ID="Nombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <asp:Button ID="Guardar" runat="server" Text="Guardar especialidad" OnClick="Guardar_Click" CssClass="btn btn-primary" />
            <asp:Button ID="Cancelar" runat="server" Text="Cancelar edición" OnClick="Cancelar_Click" CssClass="btn btn-outline-secondary" Visible="false" />
        </div>
    </asp:Panel>
    <section class="panel">
        <h2>Especialidades registradas</h2>
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="false" OnRowCommand="Tabla_Comando" EmptyDataText="No hay especialidades registradas.">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" />
                    <asp:BoundField DataField="Nombre" HeaderText="Especialidad" />
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="Editar" CommandName="Editar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
