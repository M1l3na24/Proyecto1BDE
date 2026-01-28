-- Conectarse a la base de datos
\c spa;

-- Crear llave primaria Clientes
ALTER TABLE Clientes
ADD CONSTRAINT pk_clientes
PRIMARY KEY (num_cliente);

-- Crear llave primaria Paquetes
ALTER TABLE Paquetes
ADD CONSTRAINT pk_paquetes
PRIMARY KEY (id_paquete);

-- Crear llave primaria Servicio
ALTER TABLE Servicios
ADD CONSTRAINT pk_servicio
PRIMARY KEY (id_servicio);

-- Crear llave primaria Empleado
ALTER TABLE Empleados
ADD CONSTRAINT pk_empleado
PRIMARY KEY (num_empleado);

-- Crear llave primaria Camas_Solares
ALTER TABLE Camas_Solares
ADD CONSTRAINT pk_camas_solares
PRIMARY KEY (num_serie);

-- Crear llave primaria Instalaciones
ALTER TABLE Instalaciones
ADD CONSTRAINT pk_instalaciones
PRIMARY KEY (id_instalacion);


-- Crear llave foranea Contratan
ALTER TABLE Contratan
ADD CONSTRAINT pk_contratan
PRIMARY KEY (num_cliente, id_paquete, fecha_c);  -- agregamos fecha_c porque un cliente puede contratar el mismo paquete multiples veces en diferentes fechas

ALTER TABLE Contratan
ADD CONSTRAINT fk_contratan_cliente
FOREIGN KEY (num_cliente) REFERENCES Clientes(num_cliente)
;

ALTER TABLE Contratan
ADD CONSTRAINT fk_contratan_paquete
FOREIGN KEY (id_paquete) REFERENCES Paquetes(id_paquete)
;
-- Crear llave foranea Incluyen
ALTER TABLE Incluyen
ADD CONSTRAINT pk_incluyen
PRIMARY KEY (id_paquete,id_servicio);

ALTER TABLE Incluyen
ADD CONSTRAINT fk_incluyen_paquetes
FOREIGN KEY (id_paquete) REFERENCES Paquetes(id_paquete)
;

ALTER TABLE Incluyen
ADD CONSTRAINT fk_incluyen_servicios
FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
;

---Crear llave foranea Realizan

-- Llave primaria compuesta de Realizan
ALTER TABLE Realizan
ADD CONSTRAINT pk_realizan
PRIMARY KEY (id_servicio, num_empleado, fecha_r); -- agregamos fecha_r porque un empleado puede hacer el mismo servicio multiples veces en diferentes fechas

ALTER TABLE Realizan
ADD CONSTRAINT fk_realizan_servicio
FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
;

ALTER TABLE Realizan
ADD CONSTRAINT fk_realizan_empleado
FOREIGN KEY (num_empleado) REFERENCES Empleados(num_empleado)
;

---Crear llave foranea Ofrecen

ALTER TABLE Ofrecen
ADD CONSTRAINT pk_ofrecen
PRIMARY KEY (id_servicio, num_serie, id_instalacion);

ALTER TABLE Ofrecen
ADD CONSTRAINT fk_ofrecen_servicio
FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
;

ALTER TABLE Ofrecen
ADD CONSTRAINT fk_ofrecen_cama
FOREIGN KEY (num_serie) REFERENCES Camas_Solares(num_serie)
;

ALTER TABLE Ofrecen
ADD CONSTRAINT fk_ofrecen_instalacion
FOREIGN KEY (id_instalacion) REFERENCES Instalaciones(id_instalacion)
;


