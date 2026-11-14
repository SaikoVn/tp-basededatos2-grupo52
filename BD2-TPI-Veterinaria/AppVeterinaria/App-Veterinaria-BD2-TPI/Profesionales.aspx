<%@ Page Language="C#" Title="Profesionales" MasterPageFile="~/Master.Master" AutoEventWireup="true" CodeBehind="Profesionales.aspx.cs" Inherits="VeterinariaWeb.PaginaProfesionales" %>
<asp:Content runat="server" ContentPlaceHolderID="Contenido">
    <section class="panel">
        <h2><asp:Label ID="TituloFormulario" runat="server" Text="Registrar profesional" /></h2>
        <div class="campos">
            <label>Nombre<asp:TextBox ID="Nombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Apellido<asp:TextBox ID="Apellido" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Matrícula<asp:TextBox ID="Matricula" runat="server" CssClass="form-control" MaxLength="20" /></label>
            <label>Especialidad<asp:DropDownList ID="Especialidad" runat="server" CssClass="form-select" /></label>
            <label>Teléfono (opcional)<asp:TextBox ID="Telefono" runat="server" CssClass="form-control" MaxLength="30" /></label>
            <label>Correo (opcional)<asp:TextBox ID="Correo" runat="server" CssClass="form-control" MaxLength="100" /></label>
            <asp:Button ID="Crear" runat="server" Text="Guardar profesional" OnClick="Crear_Click" CssClass="btn btn-primary" />
            <asp:Button ID="CancelarEdicion" runat="server" Text="Cancelar edición" OnClick="CancelarEdicion_Click" CssClass="btn btn-outline-secondary" Visible="false" />
        </div>
    </section>
    <section class="panel">
        <h2>Filtrar profesionales</h2>
        <div class="campos">
            <label>Matrícula exacta<asp:TextBox ID="FiltroMatricula" runat="server" CssClass="form-control" MaxLength="20" /></label>
            <label>Nombre<asp:TextBox ID="FiltroNombre" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Apellido<asp:TextBox ID="FiltroApellido" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <label>Especialidad<asp:TextBox ID="FiltroEspecialidad" runat="server" CssClass="form-control" MaxLength="60" /></label>
            <asp:Button ID="Filtrar" runat="server" Text="Filtrar" OnClick="Filtrar_Click" CssClass="btn btn-primary" />
            <a href="Profesionales.aspx">Limpiar filtros</a>
        </div>
    </section>
    <section class="panel">
        <h2>Profesionales registrados</h2>
        <div class="table-responsive">
            <asp:GridView ID="Tabla" runat="server" CssClass="table table-hover" GridLines="None"
                AutoGenerateColumns="false" OnRowCommand="Tabla_Comando" EmptyDataText="No hay profesionales que coincidan con esos filtros.">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" />
                    <asp:BoundField DataField="Matrícula" HeaderText="Matrícula" />
                    <asp:BoundField DataField="Profesional" HeaderText="Profesional" />
                    <asp:BoundField DataField="Especialidad" HeaderText="Especialidad" />
                    <asp:BoundField DataField="Estado" HeaderText="Activo" />
                    <asp:TemplateField HeaderText="Acciones">
                        <ItemTemplate>
                            <asp:Button runat="server" Text="Editar" CommandName="Editar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-primary" />
                            <asp:Button runat="server" Text="Desactivar" CommandName="Desactivar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# (bool)Eval("Estado") %>'
                                OnClientClick="return confirm('¿Desactivar este profesional?');" />
                            <asp:Button runat="server" Text="Activar" CommandName="Activar"
                                CommandArgument='<%# Eval("ID") %>' CssClass="btn btn-sm btn-outline-secondary"
                                Visible='<%# !(bool)Eval("Estado") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </section>
</asp:Content>
