using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Facturacion
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string matricula, string profesional)
        {
            matricula = matricula ?? "";
            profesional = profesional ?? "";
            return db.Consultar(@"SELECT id_profesional ID, matricula Matrícula,
                    CONCAT(apellido_profesional, ', ', nombre_profesional) Profesional,
                    cantidad_pagos Pagos, total_facturado Total
                    FROM dbo.vw_ResumenFacturacionPorProfesional
                    WHERE (@matricula = '' OR matricula = @matricula)
                      AND (@profesional = '' OR nombre_profesional LIKE '%' + @profesional + '%'
                           OR apellido_profesional LIKE '%' + @profesional + '%')
                    ORDER BY apellido_profesional, nombre_profesional, id_profesional",
                Param("@matricula", matricula), Param("@profesional", profesional));
        }
    }
}