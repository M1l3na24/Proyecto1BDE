-- Conectarse a la base de datos
\c spa;

-- NOTA: Nuestras tablas catalogo son; clientes, paquetes, servicios, empleados, camas_solares, instalaciones

-- Creacion de procedimiento para la tabla catalogo clientes

CREATE OR REPLACE PROCEDURE sp_inserta_cliente(
	num_cliente_p CHAR(8),
	nombres_c_p VARCHAR(30),
	apellido_paterno_c_p VARCHAR(30),
	apellido_materno_c_p VARCHAR(30))
LANGUAGE plpgsql
AS $$
BEGIN
	-- checamos constraints
	-- verificamos que los parámetros sean correctos y esten completos
	IF num_cliente_p IS NULL OR nombres_c_p IS NULL OR apellido_paterno_c_p IS NULL THEN
    	RAISE EXCEPTION 'num_cliente, nombres_c y apellido_paterno_c son parametros obligatorios';
  	END IF;
	
	IF nombres_c_p !~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ\s]+$' THEN
        RAISE EXCEPTION 'El nombre solo puede contener letras y espacios: %', nombres_c_p;
    	END IF;

	IF apellido_paterno_c_p !~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ]+$' THEN
        RAISE EXCEPTION 'El apellido paterno solo puede contener letras: %', apellido_paterno_c_p;
    	END IF;

	-- si todo bien insertamos
	INSERT INTO clientes (num_cliente, nombres_c, apellido_paterno_c, apellido_materno_c)
	VALUES(num_cliente_p, nombres_c_p, apellido_paterno_c_p, apellido_materno_c_p);

	-- avisamos que lo hicimos correctamente
	RAISE NOTICE 'Cliente % insertado correctamente', num_cliente_p;

-- cachamos excepciones por si ya existe el num_cliente
EXCEPTION
	WHEN unique_violation THEN
        RAISE EXCEPTION 'El cliente % ya existe', num_cliente_p;
END; $$;






-- Creacion de procedimiento para la tabla catalogo paquetes

CREATE OR REPLACE PROCEDURE sp_inserta_paquetes(
	id_paquete_p CHAR(8),
        nombre_paquete_p VARCHAR(30))
LANGUAGE plpgsql
AS $$
BEGIN
	-- checamos constraints
	IF nombre_paquete_p IS NULL THEN
    	RAISE EXCEPTION 'nombre_paquete es un parametro obligatorio';
  	END IF;

	-- si todo bien insertamos
	INSERT INTO paquetes (id_paquete, nombre_paquete)
	VALUES(id_paquete_p, nombre_paquete_p);

	-- avisamos que lo hicimos correctamente
	RAISE NOTICE 'Paquete % insertado correctamente', id_paquete_p;

-- cachamos excepciones por si ya existe el id_paquete
EXCEPTION
	WHEN unique_violation THEN
        RAISE EXCEPTION 'El Paquete % ya existe', id_paquete_p;
END; $$;






-- Creacion de procedimiento para la tabla catalogo servicios

CREATE OR REPLACE PROCEDURE sp_inserta_servicios(
	id_servicio_p CHAR(8),
        nombre_servicio_p VARCHAR(30))
LANGUAGE plpgsql
AS $$
BEGIN
	-- checamos constraints
	IF nombre_servicio_p IS NULL THEN
    	RAISE EXCEPTION 'nombre_servicio es un parametro obligatorio';
  	END IF;

	-- si todo bien insertamos
	INSERT INTO servicios(id_servicio, nombre_servicio)
	VALUES(id_servicio_p, nombre_servicio_p);

	-- avisamos que lo hicimos correctamente
	RAISE NOTICE 'Servicio % insertado correctamente', id_servicio_p;

-- cachamos excepciones por si ya existe el id_servicio
EXCEPTION
	WHEN unique_violation THEN
        RAISE EXCEPTION 'El Servicio % ya existe', id_servicio_p;
END; $$;







-- Creacion de procedimiento para la tabla catalogo empleados

CREATE OR REPLACE PROCEDURE sp_inserta_empleados(
	num_empleado_p CHAR(8),
        nombres_e_p VARCHAR(30),
        apellido_paterno_e_p VARCHAR(30),
	apellido_materno_e_p VARCHAR(30),
	categoria_e_p VARCHAR(30))
LANGUAGE plpgsql
AS $$
BEGIN
	-- checamos constraints
	IF num_empleado_p IS NULL OR nombres_e_p IS NULL OR apellido_paterno_e_p IS NULL OR categoria_e_p IS NULL THEN
    	RAISE EXCEPTION 'num_empleado, nombres_e, apellido_paterno_e y categoria_e son parametros obligatorios';
  	END IF;

	IF categoria_e_p NOT IN ('Recepcionista', 'Terapeuta', 'Masajista', 'Esteticista', 'Gerente') THEN RAISE EXCEPTION 'Categoria de empleado no valida: %. Las categorías permitidas son: Recepcionista, Terapeuta, Masajista, Esteticista, Gerente', categoria_e_p;
	END IF;
	
	IF nombres_e_p !~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ\s]+$' THEN
        RAISE EXCEPTION 'El nombre solo puede contener letras y espacios: %', nombres_e_p;
    	END IF;

	IF apellido_paterno_e_p !~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ]+$' THEN
        RAISE EXCEPTION 'El apellido paterno solo puede contener letras: %', apellido_paterno_e_p;
    	END IF;

	-- si todo bien insertamos
	INSERT INTO empleados(num_empleado, nombres_e, apellido_paterno_e, apellido_materno_e, categoria_e)
	VALUES(num_empleado_p, nombres_e_p, apellido_paterno_e_p, apellido_materno_e_p, categoria_e_p);

	-- avisamos que lo hicimos correctamente
	RAISE NOTICE 'Empleado % insertado correctamente', num_empleado_p;

-- cachamos excepciones por si ya existe el num_empleado_p
EXCEPTION
	WHEN unique_violation THEN
        RAISE EXCEPTION 'El Empleado % ya existe', num_empleado_p;
END; $$;






-- Creacion de procedimiento para la tabla catalogo camas_solares

CREATE OR REPLACE PROCEDURE sp_inserta_camas_solares(
	num_serie_p CHAR(8),
	num_focos_p INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	-- checamos constraints
	IF num_focos_p <= 0 THEN
    	RAISE EXCEPTION 'El numero de focos debe ser positivo.';
  	END IF;

	-- si todo bien insertamos
	INSERT INTO camas_solares (num_serie, num_focos)
	VALUES(num_serie_p, num_focos_p);

	-- avisamos que lo hicimos correctamente
	RAISE NOTICE 'Cama solar % insertada correctamente', num_serie_p;

-- cachamos excepciones por si ya existe el num_serie
EXCEPTION
	WHEN unique_violation THEN
        RAISE EXCEPTION 'La cama % ya existe', num_serie_p;
END; $$;






-- Creacion de procedimiento para la tabla catalogo instalaciones

CREATE OR REPLACE PROCEDURE sp_inserta_instalaciones(
	id_instalacion_p CHAR(8),
	num_camas_p INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	-- checamos constraints
	IF num_camas_p <= 0 THEN
    	RAISE EXCEPTION 'El numero de camas solares debe ser positivo.';
  	END IF;

	-- si todo bien insertamos
	INSERT INTO instalaciones(id_instalacion, num_camas)
	VALUES(id_instalacion_p, num_camas_p);

	-- avisamos que lo hicimos correctamente
	RAISE NOTICE 'Instalacion % insertada correctamente', id_instalacion_p;

-- cachamos excepciones por si ya existe el id_instalacion
EXCEPTION
	WHEN unique_violation THEN
        RAISE EXCEPTION 'La instalacion % ya existe', id_instalacion_p;
END; $$;



-- PRUEBAS
CALL sp_inserta_cliente('CL000016', 'Sofía', 'Martínez', 'López');
CALL sp_inserta_cliente('CL000019', NULL, 'Hernández', 'Mora');

CALL sp_inserta_paquetes('PK000011', 'Spa Completo Premium');
CALL sp_inserta_paquetes('PK000012', NULL);

CALL sp_inserta_servicios('SV000011', 'Masaje con Piedras Calientes');
CALL sp_inserta_servicios('SV000012', NULL);

CALL sp_inserta_empleados('EM000011', 'Laura', 'Díaz', 'Romero', 'Esteticista');
CALL sp_inserta_empleados('EM000013', 'Ana123', 'Martínez', 'Sánchez', 'Recepcionista');


CALL sp_inserta_camas_solares('CS000011', 42);
CALL sp_inserta_camas_solares('CS000012', 0);

CALL sp_inserta_instalaciones('IN000011', 15);
CALL sp_inserta_instalaciones('IN000013', -3);



