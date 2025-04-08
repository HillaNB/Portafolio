-- Nombre: Hillary Blandón Brenes
-- Fecha: 4/12/24

host cls
PROMPT ===================================================================================
PROMPT Hillary Nicole Blandon Brenes // Semana #13   
PROMPT ===================================================================================

PROMPT ===================================================================================
PROMPT  VERSION V22  04-12-2024    hora 12:03 am
PROMPT ===================================================================================
 
conn sys/506UH as sysdba;

PROMPT ===================================================================================
PROMPT  Conectado como rol Sysdba con Usuario Sys
PROMPT ===================================================================================

ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;

PROMPT ===================================================================================
PROMPT  Se elimina el usuario Nomina si existia
PROMPT ===================================================================================

DROP USER nomina CASCADE;

PROMPT ===================================================================================
PROMPT  Se crea el usuario Nomina
PROMPT ===================================================================================

CREATE USER nomina IDENTIFIED BY n123;

PROMPT ===================================================================================
PROMPT  Se da rol DBA al usuario Nomina
PROMPT ===================================================================================

GRANT dba TO nomina;

PROMPT ===================================================================================
PROMPT  Se conecta como nomina
PROMPT ===================================================================================

conn nomina/n123;

------------------------------------------------------------------------------------------
SET LINESIZE 100;
SET PAGESIZE 100;

SPOOL 'C:\Users\HillaNB\Desktop\UH\Base de datos\Quiz2\log.log'

PROMPT ===================================================================================
PROMPT Borrar las TABLESPACE
PROMPT ===================================================================================
DROP TABLESPACE DATOS INCLUDING CONTENTS;
DROP TABLESPACE INDICES INCLUDING CONTENTS;

PROMPT ===================================================================================
PROMPT Se crea TABLESPACE DATOS
PROMPT ===================================================================================
CREATE TABLESPACE DATOS 
DATAFILE 'C:\Users\HillaNB\Desktop\UH\Base de datos\Quiz2\DATOS.dbf' 
SIZE 128M REUSE AUTOEXTEND OFF;

PROMPT ===================================================================================
PROMPT Se crea TABLESPACE INDICES
PROMPT ===================================================================================
CREATE TABLESPACE INDICES 
DATAFILE 'C:\Users\HillaNB\Desktop\UH\Base de datos\Quiz2\INDICES.dbf' 
SIZE 128M REUSE AUTOEXTEND OFF;

------------------------------------------------------------------------------------------
PROMPT ===================================================================================
PROMPT Prosa del requerimiento
PROMPT ===================================================================================

PROMPT El sistema debe gestionar la informacion relacionada con las transacciones de los clientes,
PROMPT para lo cual se crearan las tablas Clientes, Productos y Transacciones.
PROMPT Estas tablas permitirán almacenar y consultar detalles clave de cada cliente, los productos
PROMPT disponibles, y las transacciones realizadas por los clientes durante el proceso de facturacion.
PROMPT Se utilizaran claves foraneas para relacionar las transacciones con los clientes y las facturas,
PROMPT permitiendo asi la integracion completa de los datos relacionados. Ademas, se gestionara un
PROMPT control del subtotal, los descuentos y los impuestos asociados a cada transaccion, asegurando
PROMPT que el sistema refleje el monto total a pagar por el cliente, asi como los detalles de cada
PROMPT producto en las facturas correspondientes.
PROMPT

PROMPT ===================================================================================
PROMPT  Se elimina tabla encabezado
PROMPT ===================================================================================
DROP TABLE Encabezado;

PROMPT ===================================================================================
PROMPT  Creacion tabla encabezado
PROMPT ===================================================================================
CREATE TABLE Encabezado (
    ID_factura 			NUMBER(3)			NOT NULL,
    fecha_factura 		DATE 				NOT NULL,
    total_factura 		NUMBER(10) 			NOT NULL,
    correo 				VARCHAR2(80)		NOT NULL
)tablespace users;

-----------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Se elimina tabla detalle factura
PROMPT ===================================================================================
DROP TABLE Detalle_Factura;

PROMPT ===================================================================================
PROMPT  Creacion detalle factura
PROMPT ===================================================================================
CREATE TABLE Detalle_Factura (
    ID_factura 			NUMBER(3)			NOT NULL,
    ID_linea 			NUMBER(3) 			NOT NULL,
    cod_producto 		NUMBER(10) 			NOT NULL,
    cantidad 			NUMBER(3)			NOT NULL CHECK (cantidad > 0),
	precio_unitario		NUMBER(10)			NOT NULL
)tablespace users;

------------------------------------------------------------------------------------------
PROMPT ===================================================================================
PROMPT  Se elimina tabla clientes
PROMPT ===================================================================================
DROP TABLE Clientes;

PROMPT ===================================================================================
PROMPT  Creacion tabla clientes
PROMPT ===================================================================================
CREATE TABLE Clientes (
    ID_cliente 			NUMBER(3)			NOT NULL,
    nombre 				VARCHAR2(100)       NULL,
    ced 				VARCHAR2(20)		NULL,
    correo 				VARCHAR2(80)		NOT NULL
	CONSTRAINT chk_correo CHECK (correo LIKE '%@%')
)tablespace users;

-- PROMPT ===================================================================================
-- PROMPT  Se crea trigger INSERT para tabla clientes
-- PROMPT ===================================================================================

-- CREATE OR REPLACE TRIGGER trg_no_insert_clientes BEFORE INSERT ON Clientes
-- FOR EACH ROW
-- BEGIN
    -- RAISE_APPLICATION_ERROR(-20001, 'No se pueden insertar mas registros a esta tabla');
-- END;
-- /
-- show error

-- PROMPT ===================================================================================
-- PROMPT  Se crea trigger UPDATE para tabla clientes 
-- PROMPT ===================================================================================

-- CREATE OR REPLACE TRIGGER trg_no_update_clientes BEFORE UPDATE ON Clientes
-- FOR EACH ROW
-- BEGIN
    -- RAISE_APPLICATION_ERROR(-20001, 'No se pueden actualizar registros en esta tabla');
-- END;
-- /
-- show error

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Se elimina tabla productos
PROMPT ===================================================================================
DROP TABLE Productos;


PROMPT ===================================================================================
PROMPT  Creacion tabla productos
PROMPT ===================================================================================
CREATE TABLE Productos (
    ID_producto     	NUMBER(3) 			NOT NULL,
    cantidad    	 	NUMBER(3) 			NOT NULL,
    cod_producto        NUMBER(3) 			NOT NULL,                    
    descripcion     	VARCHAR2(100) 		NOT NULL,                 
    precio_unitario 	NUMBER(10) 			NOT NULL,
	monto				NUMBER(10) 			NOT NULL
) tablespace users;

-- PROMPT ===================================================================================
-- PROMPT  Se crea trigger INSERT para tabla productos 
-- PROMPT ===================================================================================

-- CREATE OR REPLACE TRIGGER trg_no_insert_productos BEFORE INSERT ON Productos
-- FOR EACH ROW
-- BEGIN
    -- RAISE_APPLICATION_ERROR(-20002, 'No se pueden insertar mas registros a esta tabla');
-- END;
-- /
-- show error

-- PROMPT ===================================================================================
-- PROMPT  Se crea trigger UPDATE para tabla productos 
-- PROMPT ===================================================================================

-- CREATE OR REPLACE TRIGGER trg_no_update_productos BEFORE UPDATE ON Productos
-- FOR EACH ROW
-- BEGIN
    -- RAISE_APPLICATION_ERROR(-20005, 'No se pueden actualizar registros a esta tabla');
-- END;
-- /
-- show error

-----------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Se elimina tabla transacciones
PROMPT ===================================================================================
DROP TABLE Transacciones;


PROMPT ===================================================================================
PROMPT  Creacion tabla transacciones
PROMPT ===================================================================================
CREATE TABLE Transacciones (
    id_transaccion 	 	NUMBER(3) 			NOT NULL,
    ID_cliente         	NUMBER(3)          	NOT NULL,
    ID_factura         	NUMBER(3)          	NOT NULL, 						   
	subtotal           	NUMBER              NOT NULL,                           
    descuento       	NUMBER 				NOT NULL,                          
    imp_teatro      	NUMBER 				DEFAULT 0,                        
    imp_municipal   	NUMBER 				DEFAULT 0,                         
    imp_venta  			NUMBER 				NOT NULL CHECK (imp_venta >= 0),                          
    total	          	NUMBER 				NOT NULL                            
) tablespace users;

-- PROMPT ===================================================================================
-- PROMPT  Se crea trigger INSERT para tabla transacciones 
-- PROMPT ===================================================================================

-- CREATE OR REPLACE TRIGGER trg_no_insert_transacciones BEFORE INSERT ON Transacciones
-- FOR EACH ROW
-- BEGIN
    -- RAISE_APPLICATION_ERROR(-20003, 'No se pueden insertar mas registros a esta tabla');
-- END;
-- /
-- show error

-- PROMPT ===================================================================================
-- PROMPT  Se crea trigger DELETE para tabla transacciones 
-- PROMPT ===================================================================================

-- CREATE OR REPLACE TRIGGER trg_no_delete_transacciones BEFORE DELETE ON Transacciones
-- FOR EACH ROW
-- BEGIN
    -- RAISE_APPLICATION_ERROR(-20006, 'No se pueden eliminar registros a esta tabla');
-- END;
-- /
-- show error

------------------------------------------------------------------------------------------

PROMPT =================================================================================
PROMPT Creacion las PK
PROMPT =================================================================================

ALTER TABLE Encabezado ADD CONSTRAINT encabezado_pk PRIMARY KEY (ID_factura) USING INDEX TABLESPACE users;

ALTER TABLE Detalle_Factura ADD CONSTRAINT detalle_factura_pk PRIMARY KEY (ID_factura, ID_linea) USING INDEX TABLESPACE users;

ALTER TABLE Clientes ADD CONSTRAINT clientes_pk PRIMARY KEY (ID_cliente) USING INDEX TABLESPACE users;

ALTER TABLE Productos ADD CONSTRAINT productos_pk PRIMARY KEY (cod_producto) USING INDEX TABLESPACE users;

ALTER TABLE Transacciones ADD CONSTRAINT transacciones_pk PRIMARY KEY (id_transaccion) USING INDEX TABLESPACE users;

PROMPT =================================================================================
PROMPT Creacion las FK 
PROMPT =================================================================================

ALTER TABLE Detalle_Factura ADD CONSTRAINT
detalle_factura_fk_factura FOREIGN KEY (ID_factura) REFERENCES Encabezado(ID_factura);

ALTER TABLE Detalle_Factura ADD CONSTRAINT
detalle_factura_fk_producto FOREIGN KEY (cod_producto) REFERENCES Productos(cod_producto);

ALTER TABLE Transacciones ADD CONSTRAINT
transacciones_fk_cliente FOREIGN KEY (ID_cliente) REFERENCES Clientes(ID_cliente);

ALTER TABLE Transacciones ADD CONSTRAINT
transacciones_fk_factura FOREIGN KEY (ID_factura) REFERENCES Encabezado(ID_factura);

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Insert Encabezado
PROMPT ===================================================================================
INSERT INTO Encabezado (ID_factura, fecha_factura, total_factura, correo) 
VALUES (1, TO_DATE('2023-07-12', 'YYYY-MM-DD'), 13699.98, 'blandonhillary162@gmail.com');

PROMPT ===================================================================================
PROMPT  Commit para Encabezado
PROMPT ===================================================================================
commit;

PROMPT ===================================================================================
PROMPT  Selecciona Encabezado
PROMPT ===================================================================================
select * from Encabezado;

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Insert Productos
PROMPT ===================================================================================
INSERT INTO Productos (ID_producto, cantidad, cod_producto, descripcion, precio_unitario, monto)
VALUES (1, 2, 0001, 'ADULTO 2D', 5326.12, 1052.24);
INSERT INTO Productos (ID_producto, cantidad, cod_producto, descripcion, precio_unitario, monto)
VALUES(2, 2, 838, 'BOOKING FEE', 309.73, 619.46);

PROMPT ===================================================================================
PROMPT  Commit para Productos
PROMPT ===================================================================================
commit;

PROMPT ===================================================================================
PROMPT  Selecciona Productos
PROMPT ===================================================================================
select * from Productos;

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Insert Detalle factura
PROMPT ===================================================================================
INSERT INTO Detalle_Factura (ID_factura, ID_linea, cod_producto, cantidad, precio_unitario)
VALUES (1, 1, 0001, 2, 5326.12);
INSERT INTO Detalle_Factura (ID_factura, ID_linea, cod_producto, cantidad, precio_unitario)
VALUES (1, 2, 838, 2, 309.73);

PROMPT ===================================================================================
PROMPT  Commit para Factura
PROMPT ===================================================================================
COMMIT;

PROMPT ===================================================================================
PROMPT  Selecciona Detalle factura
PROMPT ===================================================================================
select * from Detalle_Factura;

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Insert Clientes
PROMPT ===================================================================================
INSERT INTO Clientes (ID_cliente, nombre, ced, correo)
VALUES (1, NULL, NULL, 'blandonhillary162@gmail.com');

PROMPT ===================================================================================
PROMPT  Commit para Cientes
PROMPT ===================================================================================
COMMIT;

PROMPT ===================================================================================
PROMPT  Selecciona clientes
PROMPT ===================================================================================
select * from Clientes;


PROMPT ===================================================================================
PROMPT  Insert Transacciones
PROMPT ===================================================================================
INSERT INTO Transacciones (id_transaccion, ID_cliente, ID_factura, subtotal, descuento, imp_teatro, imp_municipal, imp_venta, total)
VALUES (1, 1,1, 11271.70, 0, 319.56, 532.62, 1576.10, 13699.98);

PROMPT ===================================================================================
PROMPT  Commit para Transacciones
PROMPT ===================================================================================
COMMIT;

PROMPT ===================================================================================
PROMPT  Selecciona Transacciones
PROMPT ===================================================================================
select * from Transacciones;


-------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Normalizacion 3FN
PROMPT ===================================================================================

PROMPT ===================================================================================
PROMPT  Primera Forma Normal: 1FN
PROMPT ===================================================================================
PROMPT En la primera se asegura que todos los atributos contienen valores atomicos y que 
PROMPT cada fila es unica. Por lo que ya las tablas anteriormente creadas cumplen con 1FN  
PROMPT porque cada celda tiene un solo valor y no hay filas duplicadas.
PROMPT

PROMPT ===================================================================================
PROMPT  Segunda Forma Normal: 2FN
PROMPT ===================================================================================
PROMPT Se debe eliminar la redundancia parcial y asegurar que cada atributo no clave
PROMPT dependa totalmente de la clave primaria. Se divide la tabla en multiples tablar para
PROMPT evitar redundancias.
PROMPT

PROMPT ===================================================================================
PROMPT  Ejemplo de Segunda Forma Normal: 2FN
PROMPT ===================================================================================
INSERT INTO Encabezado (ID_factura, fecha_factura, total_factura, correo)
VALUES (2, TO_DATE('2024-11-01', 'YYYY-MM-DD'), 4500.2, 'rodolfobrenes@ejemplo.com');
INSERT INTO Encabezado (ID_factura, fecha_factura, total_factura, correo)
VALUES (3, TO_DATE('2024-11-02', 'YYYY-MM-DD'), 5500.12, 'johanbastos@ejemplo.com');

INSERT INTO Clientes (ID_cliente, nombre, ced, correo)
VALUES (2, 'Rodolfo Brenes', NULL , 'rodolfobrenes@ejemplo.com');
INSERT INTO Clientes (ID_cliente, nombre, ced, correo)
VALUES (3, 'Johan Bastos', NULL, 'johanbastos@ejemplo.com');

PROMPT ===================================================================================
PROMPT Tercera Forma Normal: 3FN
PROMPT ===================================================================================
PROMPT Aca los atributos no deben depender de otros atributos no claves.
PROMPT

PROMPT ===================================================================================
PROMPT Ejemplo de Tercera Forma Normal: 3FN
PROMPT ===================================================================================
INSERT INTO Transacciones (id_transaccion, ID_cliente, ID_factura, subtotal, descuento, imp_teatro, imp_municipal, imp_venta, total)
VALUES (5, 2, 2, 11271.70, 0, 319.56, 532.62, 1576.10, 13699.98);
INSERT INTO Transacciones(id_transaccion, ID_cliente, ID_factura, subtotal, descuento, imp_teatro, imp_municipal, imp_venta, total)
VALUES (6, 3, 3, 5026.12, 0, 319.56, 300, 1000, 5376.12);

-------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT Creacion de secuencias de las 5 tablas
PROMPT ===================================================================================

CREATE SEQUENCE sec_encabezado START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sec_bit_encabezado START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sec_detalle_factura START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sec_bit_detalle_factura START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sec_clientes START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sec_bit_clientes START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sec_productos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sec_bit_productos START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE sec_transacciones START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sec_bit_transacciones START WITH 1 INCREMENT BY 1;

commit;

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT Procedimientos almacenados para la tabla encabezado
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_ins_encabezado(Pfecha_factura IN DATE,Ptotal_factura IN NUMBER,
  Pcorreo IN NUMBER) IS
BEGIN
	 INSERT INTO encabezado (ID_factura, fecha_factura, total_factura, correo)
	 VALUES (sec_encabezado.NEXTVAL, Pfecha_factura, Ptotal_factura, Pcorreo);
END prc_ins_encabezado;
/
show error

CREATE OR REPLACE PROCEDURE prc_bor_encabezado(
  Pid_factura IN NUMBER) IS
BEGIN
  DELETE FROM encabezado WHERE ID_factura = Pid_factura;
END prc_bor_encabezado;
/
show error

CREATE OR REPLACE PROCEDURE prc_act_encabezado(
  Pid_factura IN NUMBER,
  Pfecha_factura IN DATE,
  Ptotal_factura IN NUMBER,
  Pcorreo IN VARCHAR2) IS
BEGIN
  UPDATE encabezado
  SET fecha_factura = Pfecha_factura,
      total_factura = Ptotal_factura,
      correo = Pcorreo
  WHERE ID_factura = Pid_factura;
END prc_act_encabezado;
/
show error

PROMPT ===================================================================================
PROMPT Procedimientos almacenados para la tabla detalle_factura
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_ins_detalle_factura(PID_linea IN NUMBER,
Pcod_producto IN NUMBER, Pcantidad IN NUMBER, Pprecio_unitario IN NUMBER) IS
BEGIN
    INSERT INTO Detalle_Factura (ID_factura, ID_linea, cod_producto, cantidad, precio_unitario)
    VALUES (sec_detalle_factura.NEXTVAL, PID_linea, Pcod_producto, Pcantidad, Pprecio_unitario);
END prc_ins_detalle_factura;
/
show error

CREATE OR REPLACE PROCEDURE prc_bor_detalle_factura(
  PID_factura IN NUMBER,
  PID_linea IN NUMBER) IS
BEGIN
  DELETE FROM Detalle_Factura WHERE ID_factura = PID_factura AND ID_linea = PID_linea;
END prc_bor_detalle_factura;
/
show error

CREATE OR REPLACE PROCEDURE prc_act_detalle_factura(
  PID_factura IN NUMBER,
  PID_linea IN NUMBER,
  Pcod_producto IN NUMBER,
  Pcantidad IN NUMBER,
  Pprecio_unitario IN NUMBER) IS
BEGIN
  UPDATE Detalle_Factura
  SET cod_producto = Pcod_producto,
      cantidad = Pcantidad,
      precio_unitario = Pprecio_unitario
  WHERE ID_factura = PID_factura AND ID_linea = PID_linea;
END prc_act_detalle_factura;
/
show error

PROMPT ===================================================================================
PROMPT Procedimientos almacenados para la tabla clientes
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_ins_clientes(Pnombre IN VARCHAR2, Pced IN VARCHAR2,
Pcorreo IN VARCHAR2) IS
BEGIN
    INSERT INTO Clientes (ID_cliente, nombre, ced, correo)
    VALUES (sec_clientes.NEXTVAL, Pnombre, Pced, Pcorreo);
END prc_ins_clientes;
/
show error

PROMPT ===================================================================================
PROMPT Procedimientos almacenados para la tabla productos
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_ins_productos(Pcantidad IN NUMBER, Pcod_producto IN NUMBER,
Pdescripcion IN VARCHAR2, Pprecio_unitario IN NUMBER, Pmonto IN NUMBER) IS
BEGIN
    INSERT INTO Productos (ID_producto, cantidad, cod_producto, descripcion, precio_unitario, monto)
    VALUES (sec_productos.NEXTVAL, Pcantidad, Pcod_producto, Pdescripcion, Pprecio_unitario, Pmonto);
END prc_ins_productos;
/
show error

CREATE OR REPLACE PROCEDURE prc_bor_productos(
  PID_producto IN NUMBER) IS
BEGIN
  DELETE FROM Productos WHERE ID_producto = PID_producto;
END prc_bor_productos;
/
show error

CREATE OR REPLACE PROCEDURE prc_act_productos(
  PID_producto IN NUMBER,
  Pcantidad IN NUMBER,
  Pcod_producto IN NUMBER,
  Pdescripcion IN VARCHAR2,
  Pprecio_unitario IN NUMBER,
  Pmonto IN NUMBER) IS
BEGIN
  UPDATE Productos
  SET cantidad = Pcantidad,
      cod_producto = Pcod_producto,
      descripcion = Pdescripcion,
      precio_unitario = Pprecio_unitario,
      monto = Pmonto
  WHERE ID_producto = PID_producto;
END prc_act_productos;
/
show error

PROMPT ===================================================================================
PROMPT Procedimientos almacenados para la tabla transacciones
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_ins_transacciones(PID_cliente IN NUMBER, PID_factura IN NUMBER,
Psubtotal IN NUMBER, Pdescuento IN NUMBER, Pimp_teatro IN NUMBER, Pimp_municipal IN NUMBER,
Pimp_venta IN NUMBER, Ptotal IN NUMBER) IS
BEGIN
    INSERT INTO Transacciones (id_transaccion, ID_cliente, ID_factura, subtotal, descuento, imp_teatro, imp_municipal, imp_venta, total)
    VALUES (sec_transacciones.NEXTVAL, PID_cliente, PID_factura, Psubtotal, Pdescuento, Pimp_teatro, Pimp_municipal, Pimp_venta, Ptotal);
END prc_ins_transacciones;
/
show error

CREATE OR REPLACE PROCEDURE prc_bor_transacciones(
  PID_transaccion IN NUMBER) IS
BEGIN
  DELETE FROM Transacciones WHERE id_transaccion = PID_transaccion;
END prc_bor_transacciones;
/
show error

CREATE OR REPLACE PROCEDURE prc_act_transacciones(
  PID_transaccion IN NUMBER,
  PID_cliente IN NUMBER,
  PID_factura IN NUMBER,
  Psubtotal IN NUMBER,
  Pdescuento IN NUMBER,
  Pimp_teatro IN NUMBER,
  Pimp_municipal IN NUMBER,
  Pimp_venta IN NUMBER,
  Ptotal IN NUMBER) IS
BEGIN
  UPDATE Transacciones
  SET ID_cliente = PID_cliente,
      ID_factura = PID_factura,
      subtotal = Psubtotal,
      descuento = Pdescuento,
      imp_teatro = Pimp_teatro,
      imp_municipal = Pimp_municipal,
      imp_venta = Pimp_venta,
      total = Ptotal
  WHERE id_transaccion = PID_transaccion;
END prc_act_transacciones;
/
show error

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT Se crea secuencia BIT de clientes 
PROMPT ===================================================================================

SELECT SEQUENCE_NAME FROM USER_SEQUENCES WHERE SEQUENCE_NAME = 'SEC_BIT_CLIENTES';

PROMPT ===================================================================================
PROMPT Tabla bitacora clientes
PROMPT ===================================================================================

CREATE TABLE BIT_CLIENTES (
    ID_cambio         NUMBER,              
    fecha             DATE,
    usuario           VARCHAR2(30), 
    ID_cliente        NUMBER(3),
    nombre            VARCHAR2(100),
    ced               VARCHAR2(20),
    correo            VARCHAR2(80)
) tablespace users;

PROMPT ===================================================================================
PROMPT Se crea procedimiento de insercion bitacora
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_ins_bit_clientes(Paccion IN VARCHAR2,Pid_cliente IN NUMBER,
    Pnombre IN VARCHAR2,Pced IN VARCHAR2,Pcorreo IN VARCHAR2) IS
BEGIN
    INSERT INTO BIT_CLIENTES (ID_cambio, fecha, usuario, ID_cliente, nombre, ced, correo) 
	VALUES (sec_bit_clientes.NEXTVAL, SYSDATE, USER, Pid_cliente, Pnombre, Pced, Pcorreo);
END prc_ins_bit_clientes;
/
show error

PROMPT ===================================================================================
PROMPT Tigger de bitacora clientes INSERT
PROMPT ===================================================================================

CREATE OR REPLACE TRIGGER trg_bit_clientes_insert AFTER INSERT ON Clientes
REFERENCING OLD AS OLD NEW AS NEW 
FOR EACH ROW 
BEGIN
    INSERT INTO BIT_CLIENTES (ID_cambio, fecha, usuario, ID_cliente, nombre, ced, correo)
    VALUES (sec_bit_clientes.NEXTVAL, SYSDATE, USER, :NEW.ID_cliente, :NEW.nombre, :NEW.ced,
	:NEW.correo);
END trg_bit_clientes_insert;
/
show error

PROMPT ===================================================================================
PROMPT Crea funciones comparativas
PROMPT ===================================================================================

CREATE OR REPLACE FUNCTION fun_old_new2(POld IN VARCHAR2,PNew IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
    IF POld IS NULL AND PNew IS NULL THEN
        RETURN NULL;
    ELSIF POld IS NULL AND PNew IS NOT NULL THEN
        RETURN PNew;
    ELSIF POld IS NOT NULL AND PNew IS NULL THEN
        RETURN POld;
    ELSIF POld = PNew THEN
        RETURN NULL;
    ELSE
        RETURN POld;
    END IF;
END fun_old_new2;
/
show error


PROMPT ===================================================================================
PROMPT Tigger de bitacora clientes UPDATE
PROMPT ===================================================================================

CREATE OR REPLACE TRIGGER trg_bitacora_clientes AFTER UPDATE ON Clientes
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
    prc_ins_bit_clientes(
        'U',
        :new.ID_cliente,
        fun_old_new2(:old.nombre, :new.nombre),
        fun_old_new2(:old.ced, :new.ced),
        fun_old_new2(:old.correo, :new.correo)
    );
END trg_bitacora_clientes;
/
show error

-------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Se elimina tabla ventas si existe
PROMPT ===================================================================================
DROP TABLE resumen_ventas;

PROMPT ===================================================================================
PROMPT Se crea tabla resumen ventas
PROMPT ===================================================================================

CREATE TABLE resumen_ventas (
    fecha_inicial DATE,
    fecha_final DATE,
    total_ventas NUMBER,
    cantidad_de_facturas NUMBER,
    promedio_x_factura NUMBER,
    maxima_venta NUMBER,
    minima_venta NUMBER
);

PROMPT ===================================================================================
PROMPT Se crea funcion para cada calculo
PROMPT ===================================================================================

CREATE OR REPLACE FUNCTION fn_total_ventas(pfecha_ini DATE, pfecha_fin DATE) RETURN NUMBER
	IS v_total NUMBER;
BEGIN
    SELECT SUM(d.cantidad * d.precio_unitario) INTO v_total
    FROM detalle_factura d
    JOIN encabezado e ON d.id_factura = e.id_factura
    WHERE e.fecha_factura BETWEEN pfecha_ini AND pfecha_fin;
    RETURN v_total;
END fn_total_ventas;
/
show error

PROMPT ===================================================================================
PROMPT Se crea funcion para cantidad de facturas
PROMPT ===================================================================================

CREATE OR REPLACE FUNCTION fn_cantidad_facturas(pfecha_ini DATE, pfecha_fin DATE) RETURN NUMBER
	IS v_cantidad NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_cantidad
    FROM encabezado e
    WHERE e.fecha_factura BETWEEN pfecha_ini AND pfecha_fin;
    RETURN v_cantidad;
END fn_cantidad_facturas;
/
show error

PROMPT ===================================================================================
PROMPT Se crea funcion para promedio factura
PROMPT ===================================================================================

CREATE OR REPLACE FUNCTION fn_promedio_x_factura(pfecha_ini DATE, pfecha_fin DATE) RETURN NUMBER
	IS
    v_promedio NUMBER;
    v_suma_total NUMBER := 0;
    v_cantidad NUMBER := 0;
    CURSOR c_total IS
        SELECT d.cantidad * d.precio_unitario AS total_venta
        FROM detalle_factura d
        JOIN encabezado e ON d.id_factura = e.id_factura
        WHERE e.fecha_factura BETWEEN pfecha_ini AND pfecha_fin;
BEGIN
    FOR venta IN c_total LOOP
        v_suma_total := v_suma_total + venta.total_venta;
        v_cantidad := v_cantidad + 1;
    END LOOP;
    
    BEGIN
        v_promedio := v_suma_total / v_cantidad;
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            v_promedio := -1;
    END;
    
    RETURN v_promedio;
END fn_promedio_x_factura;
/
show error

PROMPT ===================================================================================
PROMPT Se crea funcion para venta maxima
PROMPT ===================================================================================

CREATE OR REPLACE FUNCTION fn_maxima_venta(pfecha_ini DATE, pfecha_fin DATE) RETURN NUMBER IS
    v_max NUMBER;
BEGIN
    SELECT MAX(d.cantidad * d.precio_unitario) INTO v_max
    FROM detalle_factura d
    JOIN encabezado e ON d.id_factura = e.id_factura
    WHERE e.fecha_factura BETWEEN pfecha_ini AND pfecha_fin;
    RETURN v_max;
END fn_maxima_venta;
/
show error

PROMPT ===================================================================================
PROMPT Se crea funcion para venta minima
PROMPT ===================================================================================

CREATE OR REPLACE FUNCTION fn_minima_venta(pfecha_ini DATE, pfecha_fin DATE) RETURN NUMBER IS
    v_min NUMBER;
BEGIN
    SELECT MIN(d.cantidad * d.precio_unitario) INTO v_min
    FROM detalle_factura d
    JOIN encabezado e ON d.id_factura = e.id_factura
    WHERE e.fecha_factura BETWEEN pfecha_ini AND pfecha_fin;
    RETURN v_min;
END fn_minima_venta;
/
show error

PROMPT ===================================================================================
PROMPT Se crea procedimiento prc_calcula_ventas
PROMPT ===================================================================================

CREATE OR REPLACE PROCEDURE prc_calcula_ventas(pfecha_ini IN DATE, pfecha_fin IN DATE) IS
    v_total_ventas NUMBER;
    v_cantidad_facturas NUMBER;
    v_promedio_x_factura NUMBER;
    v_maxima_venta NUMBER;
    v_minima_venta NUMBER;
BEGIN
    DELETE FROM resumen_ventas;
    v_total_ventas := fn_total_ventas(pfecha_ini, pfecha_fin);
    v_cantidad_facturas := fn_cantidad_facturas(pfecha_ini, pfecha_fin);
    v_promedio_x_factura := fn_promedio_x_factura(pfecha_ini, pfecha_fin);
    v_maxima_venta := fn_maxima_venta(pfecha_ini, pfecha_fin);
    v_minima_venta := fn_minima_venta(pfecha_ini, pfecha_fin);
    
    INSERT INTO resumen_ventas (fecha_inicial, fecha_final, total_ventas, 
        cantidad_de_facturas, promedio_x_factura, maxima_venta, minima_venta
    ) VALUES (pfecha_ini, pfecha_fin, v_total_ventas, v_cantidad_facturas, 
        v_promedio_x_factura, v_maxima_venta, v_minima_venta); 
    COMMIT;
END prc_calcula_ventas;
/
show error

PROMPT ===================================================================================
PROMPT Se ejecuta procedimiento
PROMPT ===================================================================================

EXEC prc_calcula_ventas(TO_DATE('2023-01-01', 'YYYY-MM-DD'), TO_DATE('2023-12-31', 'YYYY-MM-DD'));

-------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Fin del script.
PROMPT ===================================================================================

spool off;
