\c spa;


-- clientes
ALTER TABLE clientes
ALTER COLUMN nombres_c SET NOT NULL, -- siempre existe nombre
ALTER COLUMN apellido_paterno_c SET NOT NULL, -- siempre tienes al menos un apellido
ADD CONSTRAINT nombres_sololetras
CHECK (nombres_c ~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ\s]+$'), -- solo letras
ADD CONSTRAINT apellidop_sololetras
CHECK (apellido_paterno_c ~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ]+$');



-- PAQUETES
ALTER TABLE paquetes
ALTER COLUMN nombre_paquete SET NOT NULL; -- no puede existir un paquete sin nombre



-- servicios 
ALTER TABLE servicios
ALTER COLUMN nombre_servicio SET NOT NULL; -- no puede existir servicio sin nombre

-- empleados

ALTER TABLE empleados
ALTER COLUMN nombres_e SET NOT NULL, -- siempre tienes nombre
ALTER COLUMN apellido_paterno_e SET NOT NULL, -- siempre tienes al menos un apellido
ALTER COLUMN categoria_e SET NOT NULL, -- siempre trabajas en algo especifico
ADD CONSTRAINT categoria_empleado -- debe existir la categoria de lo que trabajas
CHECK (categoria_e IN ('Recepcionista', 'Terapeuta', 'Masajista', 'Esteticista', 'Gerente')),
ADD CONSTRAINT nombrese_sololetras
CHECK (nombres_e ~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ\s]+$'), -- solo letras
ADD CONSTRAINT apellidoep_sololetras
CHECK (apellido_paterno_e ~ '^[A-ZÁÉÍÓÚÑa-záéíóúñ]+$');




-- camas solares
ALTER TABLE camas_solares
ADD CONSTRAINT camas_num_focos -- siempre hay num focos positivo (al menos 1)
CHECK (num_focos > 0);



-- instalaciones
ALTER TABLE instalaciones
ADD CONSTRAINT instalaciones_num_camas 
CHECK (num_camas > 0); -- siempre debe haber al menos 1 cama






-- contratan

ALTER TABLE contratan
ALTER COLUMN fecha_c SET DEFAULT CURRENT_DATE; -- si no meten fecha se asume que ocurrio hoy

ALTER TABLE contratan
ALTER COLUMN fecha_c SET NOT NULL, -- contratos deben tener fecha siempre
ALTER COLUMN metodo_pago SET NOT NULL, -- y debe pagarse de alguna forma establecida
DROP CONSTRAINT IF EXISTS contratan_metodo_pago,
ADD CONSTRAINT contratan_metodo_pago 
CHECK (metodo_pago IN ('Efectivo', 'TarjetaCrédito', 'TarjetaDébito', 'Transferencia', 'Depósito'));

ALTER TABLE contratan
ADD CONSTRAINT contratan_unico UNIQUE (num_cliente, id_paquete, fecha_c); -- no debe haber contratos duplicados con misma fecha

-- Para eliminar contratos de cliente que se dan de baja ya no nos interesa el cliente

ALTER TABLE contratan
DROP CONSTRAINT IF EXISTS fk_contratan_cliente,
ADD CONSTRAINT fk_contratan_cliente
FOREIGN KEY (num_cliente) REFERENCES Clientes(num_cliente)
ON DELETE CASCADE;

-- Para no eliminar paquetes con contratos

ALTER TABLE contratan
DROP CONSTRAINT IF EXISTS fk_contratan_paquete,
ADD CONSTRAINT fk_contratan_paquete
FOREIGN KEY (id_paquete) REFERENCES Paquetes(id_paquete)
ON DELETE RESTRICT;





-- ofrecen

ALTER TABLE ofrecen
DROP CONSTRAINT IF EXISTS fk_ofrecen_servicio,
ADD CONSTRAINT fk_ofrecen_servicio
FOREIGN KEY (id_servicio) 
REFERENCES Servicios(id_servicio) 
ON DELETE CASCADE; -- si eliminamos Servicio deja de estar disponible para ofertarse entonces eliminamos todos los registros relacionados

ALTER TABLE ofrecen
DROP CONSTRAINT IF EXISTS fk_ofrecen_cama,
ADD CONSTRAINT fk_ofrecen_cama
FOREIGN KEY (num_serie) 
REFERENCES Camas_Solares(num_serie) 
ON DELETE CASCADE; -- si deja de servir una cama no nos interesa historial de cuantas veces se ha ocupado, simplemente deja de ser un activo de la empresa

ALTER TABLE ofrecen
DROP CONSTRAINT IF EXISTS fk_ofrecen_instalacion,
ADD CONSTRAINT fk_ofrecen_instalacion
FOREIGN KEY (id_instalacion) 
REFERENCES Instalaciones(id_instalacion) 
ON DELETE CASCADE; -- si un spa cierra ya no forma parte de la empresa entonces no nos interesa conservar  el historial de todo lo que ofrecio 



-- incluyen

-- No eliminar servicios en paquetes porque aun podrian faltar sesiones de un cliente que contrato ese paquete

ALTER TABLE incluyen
ADD CONSTRAINT fk_incluyen_servicio
FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
ON DELETE RESTRICT; -- no podemos eliminar servicios que aun se ofertan en paquetes



-- realizan

ALTER TABLE realizan
DROP CONSTRAINT IF EXISTS fk_realizan_empleado,
ADD CONSTRAINT fk_realizan_empleado
FOREIGN KEY (num_empleado) 
REFERENCES Empleados(num_empleado) 
ON DELETE CASCADE; -- si empleado renuncia no queremos conservar sus registros de los servicios que realizo, deja de formar parte del equipo de trabajo y de estar disponible para realizar servicios.

ALTER TABLE realizan
ALTER COLUMN fecha_r SET DEFAULT CURRENT_DATE; -- sino meten fecha se asume que es hoy




