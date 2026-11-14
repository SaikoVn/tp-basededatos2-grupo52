using System;
using System.Data;
using Servicio;
using static Servicio.AccesoDatos;

namespace Dominio
{
    public class Mascotas
    {
        private readonly AccesoDatos db = new AccesoDatos();

        public DataTable Listar(string nombre, string especie, string raza, string duenio, string estado)
        {
            nombre = nombre ?? "";
            especie = especie ?? "";
            raza = raza ?? "";
            duenio = duenio ?? "";
            estado = estado ?? "";
            return db.Consultar(@"SELECT m.id_mascota ID, m.nombre Mascota, m.especie Especie,
                    m.raza Raza, m.sexo Sexo, m.fecha_nacimiento Nacimiento,
                    CONCAT(d.apellido, ', ', d.nombre) Dueño, m.activo Estado
                    FROM dbo.Mascotas m
                    INNER JOIN dbo.Duenios d ON d.id_duenio = m.id_duenio
                    WHERE (@nombre = '' OR m.nombre LIKE '%' + @nombre + '%')
                      AND (@especie = '' OR m.especie LIKE '%' + @especie + '%')
                      AND (@raza = '' OR m.raza LIKE '%' + @raza + '%')
                      AND (@duenio = '' OR d.nombre LIKE '%' + @duenio + '%'
                           OR d.apellido LIKE '%' + @duenio + '%')
                      AND (@estado = '' OR CONVERT(varchar(1), m.activo) = @estado)
                    ORDER BY m.nombre, m.id_mascota",
                Param("@nombre", nombre), Param("@especie", especie), Param("@raza", raza),
                Param("@duenio", duenio), Param("@estado", estado));
        }

        public DataTable OpcionesDuenios()
        {
            return db.Consultar(@"SELECT id_duenio, CONCAT(apellido, ', ', nombre, ' · ', dni) Dueño
                    FROM dbo.Duenios ORDER BY apellido, nombre");
        }

        public int Crear(int duenio, string nombre, string especie, string raza,
            DateTime? nacimiento, string sexo)
        {
            DataTable resultado = db.Consultar(@"INSERT dbo.Mascotas(id_duenio, nombre, especie, raza, fecha_nacimiento, sexo)
                    OUTPUT INSERTED.id_mascota
                    VALUES(@duenio, @nombre, @especie, @raza, @nacimiento, @sexo)",
                Param("@duenio", duenio), Param("@nombre", nombre), Param("@especie", especie),
                Param("@raza", raza), Param("@nacimiento", nacimiento), Param("@sexo", sexo));
            return (int)resultado.Rows[0][0];
        }

        public DataTable Obtener(int id)
        {
            return db.Consultar(@"SELECT id_mascota ID, id_duenio DuenioId, nombre Nombre,
                    especie Especie, raza Raza, fecha_nacimiento Nacimiento, sexo Sexo
                    FROM dbo.Mascotas WHERE id_mascota = @id", Param("@id", id));
        }

        public void Editar(int id, int duenio, string nombre, string especie, string raza,
            DateTime? nacimiento, string sexo)
        {
            db.Ejecutar(@"UPDATE dbo.Mascotas SET id_duenio = @duenio, nombre = @nombre,
                    especie = @especie, raza = @raza, fecha_nacimiento = @nacimiento, sexo = @sexo
                    WHERE id_mascota = @id;
                    IF @@ROWCOUNT = 0 THROW 50302, 'La mascota ya no existe.', 1;",
                Param("@id", id), Param("@duenio", duenio), Param("@nombre", nombre),
                Param("@especie", especie), Param("@raza", raza),
                Param("@nacimiento", nacimiento), Param("@sexo", sexo));
        }

        public void CambiarEstado(int id, bool activo)
        {
            db.Ejecutar(@"IF @activo = 0 AND EXISTS
                    (SELECT 1 FROM dbo.Turnos WHERE id_mascota = @id AND estado = 'pendiente')
                    THROW 50103, 'Resolvé los turnos pendientes antes de dar de baja a la mascota.', 1;
                    UPDATE dbo.Mascotas SET activo = @activo WHERE id_mascota = @id",
                Param("@id", id), Param("@activo", activo));
        }
    }
}
