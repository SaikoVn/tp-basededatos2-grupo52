using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Facturacion
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar()
        {
            return db.Consultar(@"SELECT matricula [Matrícula],CONCAT(apellido_profesional,', ',nombre_profesional) Profesional,cantidad_pagos Pagos,total_facturado [Total facturado] FROM dbo.vw_ResumenFacturacionPorProfesional ORDER BY Profesional");
        }
    }
}
