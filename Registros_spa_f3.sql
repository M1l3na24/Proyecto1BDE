-- Entramos a la base de datos spa
\c spa


-- Insertamos 10 registros (usamos LLMs para generar los registros) 

DO $$
BEGIN
 
-- Clientes
	INSERT INTO Clientes (num_cliente, nombres_c, apellido_paterno_c, apellido_materno_c) VALUES
('CL000001','Ana María','López','García'),
('CL000002','Bruno','Hernández','Mora'),
('CL000003','Carla','Ramírez','Soto'),
('CL000004','Diego','Núñez','Rojas'),
('CL000005','Elena','Vega','Paz'),
('CL000006','Fabio','Cano','Ibarra'),
('CL000007','Gina','Salas','Reyes'),
('CL000008','Hugo','Cruz','Delgado'),
('CL000009','Ivana','Ortega','León'),
('CL000010','Jorge','Pineda','Ruiz'),
('CL000011','Laura','Méndez','Castillo'),
('CL000012','Miguel','Ríos','Guerrero'),
('CL000013','Natalia','Vargas','Silva'),
('CL000014','Óscar','Delgado','Peña'),
('CL000015','Patricia','Castro','Ríos');

-- Paquetes
	INSERT INTO Paquetes (id_paquete, nombre_paquete) VALUES
('PK000001','Básico'),
('PK000002','Relax'),
('PK000003','Premium'),
('PK000004','Novias'),
('PK000005','Detox'),
('PK000006','Hidratación'),
('PK000007','Express'),
('PK000008','Gold'),
('PK000009','Antiestrés'),
('PK000010','Full Day');

-- Servicios
	INSERT INTO Servicios (id_servicio, nombre_servicio) VALUES
('SV000001','Masaje Relajante'),
('SV000002','Facial Hidratante'),
('SV000003','Manicure'),
('SV000004','Pedicure'),
('SV000005','Sauna'),
('SV000006','Baño Solar'),
('SV000007','Depilación'),
('SV000008','Exfoliación'),
('SV000009','Aromaterapia'),
('SV000010','Reflexología');


-- Empleados
	INSERT INTO Empleados (num_empleado, nombres_e, apellido_paterno_e, apellido_materno_e, categoria_e) VALUES
('EM000001','María','Pérez','Soto','Esteticista'),
('EM000002','Luis','Gómez','Rico','Masajista'),
('EM000003','Sofía','Campos','Luna','Recepcionista'),
('EM000004','Ricardo','Díaz','Neri','Gerente'),
('EM000005','Valeria','Beltrán','Iglesias','Esteticista'),
('EM000006','Tomás','Quintero','Solís','Masajista'),
('EM000007','Daniela','Rivas','Toledo','Esteticista'),
('EM000008','Pablo','Acosta','Serna','Terapeuta'),
('EM000009','Nora','Flores','Vite','Recepcionista'),
('EM000010','Ángel','Santos','Cuevas','Masajista');


-- Camas_Solares
	INSERT INTO Camas_Solares (num_serie, num_focos) VALUES
('CS000001',24),
('CS000002',28),
('CS000003',32),
('CS000004',36),
('CS000005',40),
('CS000006',24),
('CS000007',28),
('CS000008',32),
('CS000009',36),
('CS000010',40);


-- Instalaciones
	INSERT INTO Instalaciones (id_instalacion, num_camas) VALUES
('IN000001',8),
('IN000002',10),
('IN000003',6),
('IN000004',12),
('IN000005',9),
('IN000006',7),
('IN000007',11),
('IN000008',10),
('IN000009',8),
('IN000010',14);


-- Contratan
	INSERT INTO Contratan (num_cliente, id_paquete, fecha_c, metodo_pago) VALUES
('CL000001','PK000001','2025-05-01','TarjetaCrédito'),
('CL000002','PK000002','2025-05-02','Efectivo'),
('CL000003','PK000003','2025-05-03','Transferencia'),
('CL000004','PK000004','2025-05-04','TarjetaDébito'),
('CL000005','PK000005','2025-05-05','Efectivo'),
('CL000006','PK000006','2025-05-06','Depósito'),
('CL000007','PK000007','2025-05-07','Transferencia'),
('CL000008','PK000008','2025-05-08','TarjetaDébito'),
('CL000009','PK000009','2025-05-09','Efectivo'),
('CL000010','PK000010','2025-05-10','Transferencia'),
('CL000001','PK000003','2025-05-15','TarjetaCrédito'),  
('CL000002','PK000003','2025-05-16','Efectivo'),
('CL000003','PK000003','2025-05-17','Transferencia'),   
('CL000011','PK000003','2025-05-18','TarjetaDébito'),   
('CL000012','PK000003','2025-05-19','Efectivo'),        
('CL000004','PK000001','2025-05-20','Depósito'),        
('CL000005','PK000001','2025-05-21','Transferencia'),   
('CL000013','PK000004','2025-05-22','TarjetaCrédito'),  
('CL000014','PK000004','2025-05-23','Efectivo'),        
('CL000015','PK000002','2025-05-24','TarjetaDébito');


-- Ofrecen
	INSERT INTO Ofrecen (id_servicio, num_serie, id_instalacion) VALUES
('SV000006','CS000001','IN000001'),
('SV000006','CS000002','IN000002'),
('SV000006','CS000003','IN000003'),
('SV000006','CS000004','IN000004'),
('SV000006','CS000005','IN000005'),
('SV000005','CS000006','IN000006'),
('SV000005','CS000007','IN000007'),
('SV000005','CS000008','IN000008'),
('SV000005','CS000009','IN000009'),
('SV000005','CS000010','IN000010');


-- Incluyen
	INSERT INTO Incluyen (id_paquete, id_servicio) VALUES
('PK000001','SV000003'),
('PK000001','SV000004'),
('PK000002','SV000001'),
('PK000002','SV000009'),
('PK000003','SV000001'),
('PK000003','SV000002'),
('PK000004','SV000006'),
('PK000005','SV000007'),
('PK000006','SV000002'),
('PK000008','SV000010');


-- Realizan
	INSERT INTO Realizan (id_servicio, num_empleado, fecha_r) VALUES
('SV000001','EM000002','2025-05-11'),
('SV000002','EM000005','2025-05-11'),
('SV000003','EM000007','2025-05-12'),
('SV000004','EM000007','2025-05-12'),
('SV000005','EM000010','2025-05-12'),
('SV000006','EM000008','2025-05-13'),
('SV000007','EM000001','2025-05-13'),
('SV000008','EM000001','2025-05-14'),
('SV000009','EM000002','2025-05-14'),
('SV000010','EM000010','2025-05-15'),
('SV000006','EM000006','2024-04-08' ),
('SV000006','EM000008','2024-03-21');


-- Todas las inserciones anteriores son exitosas
	COMMIT;

-- Manejo de errores
EXCEPTION
    WHEN OTHERS THEN
        -- Si ocurre cualquier error, deshacemos todas las inserciones de la transaccion
        ROLLBACK;
        RAISE NOTICE 'Hubo un error al insertar los registros. No se realizo ninguna transacción.';
END $$;
