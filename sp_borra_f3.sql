\c spa;

-- una general que distinga a que tabla nos referimos

CREATE OR REPLACE PROCEDURE sp_borra(
	p_tabla VARCHAR(50),
	p_id_registro VARCHAR(8))
LANGUAGE plpgsql
AS $$
DECLARE
	cuenta_registros_eliminados INT;
BEGIN
	-- Validamos tabla
	IF p_tabla NOT IN ('clientes', 'empleados', 'paquetes', 'servicios', 'camas_solares', 'instalaciones') THEN
	RAISE EXCEPTION 'Esa tabla no se puede usar, intenta con: clientes, empleados, paquetes, servicios, camas_solares o instalaciones';
	END IF;
    
	-- Determinamos que eliminar dependiendo del nombre de la tabla
	CASE p_tabla
    		WHEN 'clientes' THEN
            	DELETE FROM clientes WHERE num_cliente = p_id_registro;
        	WHEN 'empleados' THEN
            	DELETE FROM empleados WHERE num_empleado = p_id_registro;
        	WHEN 'paquetes' THEN
            	DELETE FROM paquetes WHERE id_paquete = p_id_registro;
        	WHEN 'servicios' THEN
            	DELETE FROM servicios WHERE id_servicio = p_id_registro;
        	WHEN 'camas_solares' THEN
            	DELETE FROM camas_solares WHERE num_serie = p_id_registro;
        	WHEN 'instalaciones' THEN
            	DELETE FROM instalaciones WHERE id_instalacion = p_id_registro;
	END CASE;

	-- usamos GET DIAGNOSIS para saber cuantos registros si se eliminaron
	GET DIAGNOSTICS cuenta_registros_eliminados = ROW_COUNT;

	IF cuenta_registros_eliminados = 0 THEN
	RAISE NOTICE 'Registro: % no se pudo eliminar porque no se encontró en la tabla %',p_id_registro, p_tabla;
	ELSE
	RAISE NOTICE 'Registro: % eliminado de la tabla %',p_id_registro, p_tabla;
	END IF;

	COMMIT;

-- cachamos excepciones por constraint
        EXCEPTION 
        	WHEN foreign_key_violation THEN
            	RAISE EXCEPTION 'No se puede eliminar. El registro tiene relaciones en otras tablas.';
END;
$$;

-- pruebas
-- Ejemplos de uso
CALL sp_borra('clientes', 'CL000001'); -- SI FUNCIONA 
CALL sp_borra('empleados', 'EM000001'); -- SI FUNCIONA 
CALL sp_borra('paquetes', 'PK000001'); -- NO DEBE FUNCIONAR PORQUE YA HAY CLIENTES QUE CONTRATARON ESE PAQUETE
CALL sp_borra('servicios', 'SV000001'); -- NO DEBE FUNCIONAR PORQUE ESE SERVICIO SE OFERTA EN UN PAQUETE QUE AUN SE OFRECE
CALL sp_borra('camas_solares', 'CS000001'); -- SI FUNCIONA 
CALL sp_borra('instalaciones', 'IN000001'); -- SI FUNCIONA 




