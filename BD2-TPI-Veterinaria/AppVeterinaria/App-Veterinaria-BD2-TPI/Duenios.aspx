<%@ Page Language="C#" Title="Dueños" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Duenios.aspx.cs" Inherits="VeterinariaWeb.PaginaDuenios" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <section class="panel">
        <h2><asp:Label ID="TituloFormulario" runat="server" Text="Registrar dueño" /></h2>
        <div class="campos">
            <label>DNI<asp:TextBox ID="Dni" runat="server" CssClass="form-control" MaxLength="15" /></label>
            <label>Nombre<asp:TextBox ID="Nombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Apellido<asp:TextBox ID="Apellido" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Teléfono (opcional)<asp:TextBox ID="Telefono" runat="server" CssClass="form-control" MaxLength="30" /></label>
            <label>Correo (opcional)<asp:TextBox ID="Correo" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <label>Dirección (opcional)<asp:TextBox ID="Direccion" runat="server" CssClass="form-control" MaxLength="150" /></label>
            <asp:Button ID="Crear" runat="server" Text="Guardar dueño" OnClick="Crear_Click" CssClass="btn btn-primary" />
            <asp:Button ID="CancelarEdicion" runat="server" Text="Cancelar edición" OnClick="CancelarEdicion_Click" CssClass="btn btn-outline-secondary" Visible="false" />
        </div>
    </section>
    <section class="panel">
        <h2>Filtrar dueños</h2>
        <div class="campos">
            <label>DNI exacto<asp:TextBox ID="FiltroDni" runat="server" CssClass="form-control" MaxLength="15" /></label>
            <label>Nombre<asp:TextBox ID="FiltroNombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Apellido<asp:TextBox ID="FiltroApellido" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Duenios.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <h2>Dueños registrados</h2>
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="true" OnRowCommand="Tabla_Comando" EmptyDataText="No hay dueños que coincidan con esos filtros.">
                <Columns>
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
