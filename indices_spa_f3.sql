-- Conectarse a la base de datos
\c spa;

-- Índice para búsqueda por nombre de empleado
CREATE UNIQUE INDEX idx_empleados_nombre_unique ON Empleados (nombres_e, apellido_paterno_e, apellido_materno_e);

-- Índice para relacionar empleados con servicios realizados
CREATE INDEX idx_realizan_empleado ON Realizan (num_empleado, fecha_r);

-- Índice para contar sesiones por servicio (usando Realizan)
CREATE INDEX idx_realizan_servicio_fecha ON Realizan (id_servicio, fecha_r, num_empleado);

-- Índice para búsqueda por nombre de paquete
CREATE INDEX idx_paquetes_nombre ON Paquetes (nombre_paquete, id_paquete);

-- Índice para nombres de clientes (si necesitas ordenar o buscar por nombre)
CREATE UNIQUE INDEX idx_clientes_nombre_unique ON Clientes (nombres_c, apellido_paterno_c, apellido_materno_c);