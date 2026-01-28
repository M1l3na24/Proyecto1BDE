-- Conectarse a la base de datos
\c spa;

-- CONSULTA 1. Dado el nombre de un empleado, conocer las sesiones que ha aplicado y los clientes que atendio en cada sesión


SELECT s.nombre_servicio, r.fecha_r AS fecha_sesion, 
c.nombres_c || ' ' || c.apellido_paterno_c || ' ' || c.apellido_materno_c AS nombre_cliente
FROM Empleados e                                                 
INNER JOIN Realizan r ON e.num_empleado = r.num_empleado  	
INNER JOIN Servicios s ON r.id_servicio = s.id_servicio         
INNER JOIN Incluyen i ON s.id_servicio = i.id_servicio          
INNER JOIN Paquetes p ON i.id_paquete = p.id_paquete         
INNER JOIN Contratan ct ON p.id_paquete = ct.id_paquete          
INNER JOIN Clientes c ON ct.num_cliente = c.num_cliente          
WHERE e.nombres_e = 'Pablo' AND e.apellido_paterno_e = 'Acosta'                      
ORDER BY r.fecha_r DESC;  


-- CONSULTA 2. Dado el nombre de una cama solar, conocer el nombre de los empleados que la usan con frecuencia y el numero de sesiones que han realizado en ella


SELECT e.nombres_e || ' ' || e.apellido_paterno_e || ' ' || e.apellido_materno_e AS nombre_empleado,
COUNT(r.id_servicio) AS total_sesiones,    			-- Cuántas veces ha usado esta cama el empleado
MIN(r.fecha_r) AS primera_sesion, 				-- Primera vez que usó la cama
MAX(r.fecha_r) AS ultima_sesion					-- Última vez que usó la cama
FROM Camas_Solares cs  						
INNER JOIN Ofrecen o ON cs.num_serie = o.num_serie              -- Une camas con servicios que ofrecen
INNER JOIN Servicios s ON o.id_servicio = s.id_servicio         -- Une con nombres de servicios
INNER JOIN Realizan r ON s.id_servicio = r.id_servicio          -- Une servicios con empleados que los realizan
INNER JOIN Empleados e ON r.num_empleado = e.num_empleado       -- Une con datos de empleados
WHERE cs.num_serie = 'CS000005'                                 -- Buscamos la cama con número de serie CS000005
GROUP BY cs.num_serie, e.num_empleado, e.nombres_e, e.apellido_paterno_e, e.apellido_materno_e, s.nombre_servicio
ORDER BY total_sesiones DESC; 					-- Ordenamos por quien la usa mas.



-- CONSULTA 3. Dado el nombre de un paquete, conocer el nombre de aquellos clientes que lo han contratado y el método de pago que han usado


SELECT c.nombres_c || ' ' || c.apellido_paterno_c || ' ' || c.apellido_materno_c AS nombre_cliente_completo, ct.fecha_c AS fecha_contratacion, ct.metodo_pago
FROM Paquetes p  
INNER JOIN Contratan ct ON p.id_paquete = ct.id_paquete          -- Une paquetes con clientes que los compraron
INNER JOIN Clientes c ON ct.num_cliente = c.num_cliente          -- Une con datos de clientes
WHERE p.nombre_paquete = 'Premium'                                -- Buscamos el paquete 'Premium'
GROUP BY p.nombre_paquete, c.num_cliente, c.nombres_c, c.apellido_paterno_c, c.apellido_materno_c, ct.fecha_c, ct.metodo_pago
ORDER BY ct.fecha_c DESC; 					 -- ORDENAMOS DEL MÁS RECIENTE AL MÁS ANTIGUO





