# Clínica veterinaria · Base de Datos II

1. Abrir **AppVeterinaria/AppVeterinaria.sln**.
2. Restaurar paquetes NuGet y compilar la solución. Elegir **App-Veterinaria-BD2-TPI** como proyecto de inicio y **Default.aspx** como página inicial.
3. En **Web.config**, comprobar que la conexión Veterinaria apunte al servidor usado en SSMS. La configuración utiliza la instancia predeterminada local y autenticación de Windows. La base debe existir y el usuario de Windows debe poder consultar, modificar los registros operativos y ejecutar los procedimientos.
4. Ejecutar usando IIS Express.

## Organización del proyecto

- **AppVeterinaria/App-Veterinaria-BD2-TPI** es el proyecto web ASP.NET Web Forms. Cada pantalla tiene su página .aspx, su código de eventos .aspx.cs y su archivo de controles .designer.cs. Master.Master comparte el menú y el diseño.
- **AppVeterinaria/Dominio** agrupa las consultas y operaciones de cada sección. Por ejemplo, Turnos.cs define las operaciones que ejecutan los triggers y Pagos.cs invoca el procedimiento almacenado.
- **AppVeterinaria/Servicio** contiene AccesoDatos.cs, que abre la conexión, enlaza los parámetros SQL y devuelve los resultados mediante ADO.NET y Microsoft.Data.SqlClient.
- **Creacion de DB** reúne tablas, restricciones, funciones, vistas, procedimientos, triggers, datos y pruebas en el orden de los scripts entregados.

## Pantallas y objetos SQL

- **Inicio** cuenta Mascotas, Profesionales activos, Turnos pendientes y Pagos.
- **Dueños, Mascotas y Profesionales** consultan Duenios, Mascotas, Profesionales y Especialidades. La baja de mascota y el cambio de estado profesional actualizan activo.
- **Turnos** inserta, actualiza o elimina una fila de Turnos. Los tres triggers del script 06 controlan la superposición, validan al profesional y escriben los eventos. Reprogramar y cancelar están disponibles para turnos pendientes.
- **Pagos** invoca sp_RegistrarPagoYAtenderTurno. La tabla posterior lee Pagos junto con Turnos y muestra el comprobante y el estado devuelto por la base.
- **Agenda**, **Historial**, **Facturación** y **Frecuencia** leen respectivamente vw_AgendaTurnosActivos, vw_HistorialClinicoPorMascota, vw_ResumenFacturacionPorProfesional y vw_FrecuenciaConsultasMascotas. La última cuenta los turnos atendidos mediante fn_CantidadConsultasMascota.
- **Reporte** ejecuta sp_ReporteTurnosProfesional desde el comienzo del primer día hasta la medianoche posterior al último día seleccionado.
- **Auditoría** lee AuditoriaTurnos junto con Mascotas y Profesionales. El ID histórico se toma de la auditoría y puede consultarse después de borrar el turno.

TPI elaborado por los siguientes integrantes (Nombres y apellidos, y legajo):
1. Fernando Gabriel Quiroga Medina (33404)
2. Abril Barrientos (29696)
3. Thomas Ferreyra Willemet (33190)
4. Ignacio David Rau (33650)
