-- Conectarse a la base de datos
\c spa;

-- Crear tabla Clientes
        CREATE TABLE Clientes (
		num_cliente CHAR(8),
                nombres_c VARCHAR(30),
                apellido_paterno_c VARCHAR(30),
		apellido_materno_c VARCHAR(30)
        );

-- Crear tabla Paquetes
        CREATE TABLE Paquetes (
		id_paquete CHAR(8),
                nombre_paquete VARCHAR(30)
        );
-- Crear tabla Servicios
        CREATE TABLE Servicios (
		id_servicio CHAR(8),
                nombre_servicio VARCHAR(30)
        );

-- Crear tabla Empleados
        CREATE TABLE Empleados (
		num_empleado CHAR(8),
                nombres_e VARCHAR(30),
                apellido_paterno_e VARCHAR(30),
		apellido_materno_e VARCHAR(30),
		categoria_e VARCHAR(30)
        );
-- Crear tabla Camas_Solares
        CREATE TABLE Camas_Solares (
		num_serie CHAR(8),
		num_focos INTEGER 
        );
-- Crear tabla Instalaciones
        CREATE TABLE Instalaciones (
		id_instalacion CHAR(8),
		num_camas INTEGER
        );

-- Crear tabla de relacion Contratan
        CREATE TABLE Contratan (
		num_cliente CHAR(8),
		id_paquete CHAR(8),
                fecha_c DATE,
		metodo_pago VARCHAR(14)
        );

-- Crear tabla  de relación Ofrecen
	CREATE TABLE Ofrecen (
		id_servicio CHAR(8),
		num_serie CHAR(8),
		id_instalacion CHAR(8)
	);

-- Crear tabla de relacion Incluyen
        CREATE TABLE Incluyen (
		id_paquete CHAR(8),
		id_servicio CHAR(8)
		
        );

-- Crear tabla de relacion Realizan
        CREATE TABLE Realizan (
		id_servicio CHAR(8),
		num_empleado CHAR(8),
		fecha_r DATE
        );
