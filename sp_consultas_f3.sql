-- IMPORTANTE, nuestros usuarios NO tienen permitido hacer copias para generar archivos entonces adaptamos el metodo para que pudiéramos generar un archivo a partir de una tabla temporal.

\c spa

-- procedimiento almacenado sp_consulta que guarda en un archivo de salida las consultas generadas

CREATE OR REPLACE PROCEDURE sp_consultas(
    empleado_nombre CHARACTER VARYING,
    empleado_apellido CHARACTER VARYING,
    cama_serie CHARACTER VARYING,
    paquete_nombre CHARACTER VARYING,
    fecha_desde DATE,
    fecha_hasta DATE,
    instalacion_id CHARACTER VARYING,
    archivo_salida TEXT DEFAULT '/home/alumno06/reporte_spa.txt'
)
LANGUAGE plpgsql
AS $$
BEGIN

    -- Crear tabla temporal para almacenar el reporte
    DROP TABLE IF EXISTS tmp_consultas_export;
    CREATE TEMP TABLE tmp_consultas_export (
        line TEXT
    ); -- a veces nos lanza 'la tabla «tmp_consultas_export» no existe, omitiendo' si ejecutamos el call en otra linea pero si funciona todo bien asi que podemos omitirlo.
    
    INSERT INTO tmp_consultas_export(line)
    WITH
    
    -- CONSULTA 1. Dado el nombre de un empleado, conocer las sesiones que ha aplicado y los clientes que atendio en cada sesion

    c1_rows AS (
        SELECT
            s.nombre_servicio,
            r.fecha_r AS fecha_sesion,
            c.nombres_c || ' ' || c.apellido_paterno_c || ' ' || c.apellido_materno_c AS nombre_cliente
        FROM Empleados e
        INNER JOIN Realizan r ON e.num_empleado = r.num_empleado
        INNER JOIN Servicios s ON r.id_servicio = s.id_servicio
        INNER JOIN Incluyen i ON s.id_servicio = i.id_servicio
        INNER JOIN Paquetes p ON i.id_paquete = p.id_paquete
        INNER JOIN Contratan ct ON p.id_paquete = ct.id_paquete
        INNER JOIN Clientes c ON ct.num_cliente = c.num_cliente
        WHERE e.nombres_e = empleado_nombre AND e.apellido_paterno_e = empleado_apellido
        ORDER BY r.fecha_r DESC
    ),
    c1 AS (
        SELECT '=== CONSULTA 1: Sesiones del empleado ' || empleado_nombre || ' ' || empleado_apellido || ' ==='::TEXT
        UNION ALL SELECT 'Servicio | Fecha Sesión | Cliente'
        UNION ALL SELECT '-------------------------------------------------'
        UNION ALL
        SELECT nombre_servicio || ' | ' || fecha_sesion::text || ' | ' || nombre_cliente
        FROM c1_rows
    ),
    sep1 AS (SELECT ''::TEXT),

    -- CONSULTA 2. Dado el nombre de una cama solar, conocer el nombre de los empleados que la usan con frecuencia y el numero de sesiones que han realizado en ella

    c2_rows AS (
        SELECT
            e.nombres_e || ' ' || e.apellido_paterno_e || ' ' || e.apellido_materno_e AS nombre_empleado,
            COUNT(r.id_servicio) AS total_sesiones,
            MIN(r.fecha_r) AS primera_sesion,
            MAX(r.fecha_r) AS ultima_sesion
        FROM Camas_Solares cs
        INNER JOIN Ofrecen o ON cs.num_serie = o.num_serie
        INNER JOIN Servicios s ON o.id_servicio = s.id_servicio
        INNER JOIN Realizan r ON s.id_servicio = r.id_servicio
        INNER JOIN Empleados e ON r.num_empleado = e.num_empleado
        WHERE cs.num_serie = cama_serie
        GROUP BY e.num_empleado, e.nombres_e, e.apellido_paterno_e, e.apellido_materno_e
        ORDER BY total_sesiones DESC
    ),
    c2 AS (
        SELECT '=== CONSULTA 2: Empleados que usan la cama ' || cama_serie || ' ==='::TEXT
        UNION ALL SELECT 'Empleado | Total Sesiones | Primera Sesión | Última Sesión'
        UNION ALL SELECT '-------------------------------------------------'
        UNION ALL
        SELECT nombre_empleado || ' | ' || total_sesiones::text || ' | ' || 
               primera_sesion::text || ' | ' || ultima_sesion::text
        FROM c2_rows
    ),
    sep2 AS (SELECT ''::TEXT),

    -- CONSULTA 3. Dado el nombre de un paquete, conocer el nombre de aquellos clientes que lo han contratado y el método de pago que han usado

    c3_rows AS (
        SELECT
            c.nombres_c || ' ' || c.apellido_paterno_c || ' ' || c.apellido_materno_c AS nombre_cliente,
            ct.fecha_c AS fecha_contratacion,
            ct.metodo_pago
        FROM Paquetes p
        INNER JOIN Contratan ct ON p.id_paquete = ct.id_paquete
        INNER JOIN Clientes c ON ct.num_cliente = c.num_cliente
        WHERE p.nombre_paquete = paquete_nombre
        ORDER BY ct.fecha_c DESC
    ),
    c3 AS (
        SELECT '=== CONSULTA 3: Clientes que contrataron el paquete ' || paquete_nombre || ' ==='::TEXT
        UNION ALL SELECT 'Cliente | Fecha Contratación | Método de Pago'
        UNION ALL SELECT '-------------------------------------------------'
        UNION ALL
        SELECT nombre_cliente || ' | ' || fecha_contratacion::text || ' | ' || metodo_pago
        FROM c3_rows
    ),
    sep3 AS (SELECT ''::TEXT),

    -- CONSULTA 4: Servicios mas utilizados en un rango de fechas
    
     c4_rows AS (
        SELECT
            s.nombre_servicio,
            COUNT(r.fecha_r) AS total_sesiones,
            COUNT(DISTINCT e.num_empleado) AS empleados_diferentes,
            MAX(r.fecha_r) AS ultima_sesion
        FROM Servicios s
        INNER JOIN Realizan r ON s.id_servicio = r.id_servicio
        INNER JOIN Empleados e ON r.num_empleado = e.num_empleado
        WHERE r.fecha_r BETWEEN fecha_desde AND fecha_hasta
        GROUP BY s.id_servicio, s.nombre_servicio
        ORDER BY total_sesiones DESC, s.nombre_servicio
    ),
    c4 AS (
        SELECT '=== CONSULTA 4: Servicios más utilizados del ' || fecha_desde || ' al ' || fecha_hasta || ' ==='::TEXT
        UNION ALL SELECT 'Servicio | Total Sesiones | Empleados | Última Sesión'
        UNION ALL SELECT '-------------------------------------------------'
        UNION ALL
        SELECT nombre_servicio || ' | ' || total_sesiones::text || ' | ' || 
               empleados_diferentes::text || ' | ' || ultima_sesion::text
        FROM c4_rows
    ),
    sep4 AS (SELECT ''::TEXT),

    -- CONSULTA 5: Empleados que trabajan mas frecuentemente en una instalacion

    c5_rows AS (
        SELECT
            e.nombres_e || ' ' || e.apellido_paterno_e || ' ' || e.apellido_materno_e AS nombre_empleado,
            e.categoria_e,
            COUNT(r.id_servicio) AS total_servicios,
            MAX(r.fecha_r) AS ultima_actividad
        FROM Empleados e
        INNER JOIN Realizan r ON e.num_empleado = r.num_empleado
        INNER JOIN Servicios s ON r.id_servicio = s.id_servicio
        INNER JOIN Ofrecen o ON s.id_servicio = o.id_servicio
        INNER JOIN Instalaciones inst ON o.id_instalacion = inst.id_instalacion
        WHERE inst.id_instalacion = instalacion_id
        GROUP BY e.num_empleado, e.nombres_e, e.apellido_paterno_e, e.apellido_materno_e, e.categoria_e
        ORDER BY total_servicios DESC
    ),
    c5 AS (
        SELECT '=== CONSULTA 5: Empleados frecuentes en instalación ' || instalacion_id || ' ==='::TEXT
        UNION ALL SELECT 'Empleado | Categoría | Total Servicios | Última Actividad'
        UNION ALL SELECT '-------------------------------------------------'
        UNION ALL
        SELECT nombre_empleado || ' | ' || categoria_e || ' | ' || 
               total_servicios::text || ' | ' || ultima_actividad::text
        FROM c5_rows
        UNION ALL SELECT ''
        UNION ALL SELECT '=== FIN DEL REPORTE ==='
    )

    SELECT * FROM c1
    UNION ALL SELECT * FROM sep1
    UNION ALL SELECT * FROM c2
    UNION ALL SELECT * FROM sep2
    UNION ALL SELECT * FROM c3
    UNION ALL SELECT * FROM sep3
    UNION ALL SELECT * FROM c4
    UNION ALL SELECT * FROM sep4
    UNION ALL SELECT * FROM c5;


    -- Avisamos que todo se copio correctamente en archivo de salida
    RAISE NOTICE 'Consultas ejecutadas exitosamente!';
    RAISE NOTICE 'Para ver los resultados ejecuta: SELECT * FROM tmp_consultas_export;';
    RAISE NOTICE 'Para exportar a TXT: \copy (SELECT * FROM tmp_consultas_export) TO ''%'';', archivo_salida;
    
END;
$$;


-- como probarlo

CALL sp_consultas(
    'Pablo',         
    'Acosta',          
    'CS000005',        
    'Premium',        
    '2024-01-01',     
    '2024-12-31',     
    'IN000004',        
    '/home/alumno06/mi_reporte.txt'  
);