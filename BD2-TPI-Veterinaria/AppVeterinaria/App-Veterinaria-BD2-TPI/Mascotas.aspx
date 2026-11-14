<%@ Page Language="C#" Title="Mascotas" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Mascotas.aspx.cs" Inherits="VeterinariaWeb.PaginaMascotas" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <section class="panel">
        <h2><asp:Label ID="TituloFormulario" runat="server" Text="Registrar mascota" /></h2>
        <div class="campos">
            <label>Dueño<asp:DropDownList ID="Duenio" runat="server" CssClass="form-select" /></label>
            <label>Nombre<asp:TextBox ID="Nombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Especie<asp:TextBox ID="Especie" runat="server" CssClass="form-control" MaxLength="40" /></label>
            <label>Raza (opcional)<asp:TextBox ID="Raza" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Nacimiento (opcional)<asp:TextBox ID="Nacimiento" runat="server" CssClass="form-control" TextMode="Date" /></label>
            <label>Sexo<asp:DropDownList ID="Sexo" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Sin informar</asp:ListItem>
                <asp:ListItem Value="M">Macho</asp:ListItem>
                <asp:ListItem Value="F">Hembra</asp:ListItem>
            </asp:DropDownList></label>
            <asp:Button ID="Crear" runat="server" Text="Guardar mascota" OnClick="Crear_Click" CssClass="btn btn-primary" />
            <asp:Button ID="CancelarEdicion" runat="server" Text="Cancelar edición" OnClick="CancelarEdicion_Click" CssClass="btn btn-outline-secondary" Visible="false" />
        </div>
    </section>
    <section class="panel">
        <h2>Filtrar mascotas</h2>
        <div class="campos">
            <label>Nombre<asp:TextBox ID="FiltroNombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Especie<asp:TextBox ID="FiltroEspecie" runat="server" CssClass="form-control" MaxLength="40" /></label>
            <label>Raza<asp:TextBox ID="FiltroRaza" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Dueño<asp:TextBox ID="FiltroDuenio" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <label>Estado<asp:DropDownList ID="EstadoLista" runat="server" CssClass="form-select">
                <asp:ListItem Value="">Todos</asp:ListItem>
                <asp:ListItem Value="1">Activas</asp:ListItem>
                <asp:ListItem Value="0">Inactivas</asp:ListItem>
            </asp:DropDownList></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Mascotas.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <h2>Mascotas registradas</h2>
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="false" OnRowCommand="Tabla_Comando" EmptyDataText="No hay mascotas que coincidan con esos filtros.">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" />
                    <asp:BoundField DataField="Mascota" HeaderText="Mascota" />
                    <asp:BoundField DataField="Especie" HeaderText="Especie" />
                    <asp:BoundField DataField="Raza" HeaderText="Raza" />
                    <asp:BoundField DataField="Dueño" HeaderText="Dueño" />
                    <asp:BoundField DataField="Estado" HeaderText="Activa" />
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="Editar" CommandName="Editar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-primary" />
                            <asp:Button runat="server" Text="Dar de baja" CommandName="Baja"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# (bool)Eval("Estado") %>'
                                OnClientClick="return confirm('¿Dar de baja esta mascota?');" />
                            <asp:Button runat="server" Text="Reactivar" CommandName="Reactivar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# !(bool)Eval("Estado") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
