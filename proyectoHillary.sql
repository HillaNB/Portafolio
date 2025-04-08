-- Nombre: Hillary Blandón Brenes
-- Fecha: 23/10/2024

host cls
PROMPT ===================================================================================
PROMPT Hillary Nicole Blandon Brenes // Semana # 07      
PROMPT ===================================================================================

PROMPT ===================================================================================
PROMPT  VERSION V12  20-10-2024    hora 07:06 pm
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

PROMPT ===================================================================================
PROMPT Borrar las TABLESPACE
PROMPT ===================================================================================
DROP TABLESPACE DATOS INCLUDING CONTENTS;
DROP TABLESPACE INDICES INCLUDING CONTENTS;

PROMPT ===================================================================================
PROMPT Se crea TABLESPACE DATOS
PROMPT ===================================================================================
CREATE TABLESPACE DATOS 
DATAFILE 'C:\Users\HillaNB\Desktop\UH\Base de datos\Semana 5\DATOS.dbf' 
SIZE 128M REUSE AUTOEXTEND OFF;

PROMPT ===================================================================================
PROMPT Se crea TABLESPACE INDICES
PROMPT ===================================================================================
CREATE TABLESPACE INDICES 
DATAFILE 'C:\Users\HillaNB\Desktop\UH\Base de datos\Semana 5\INDICES.dbf' 
SIZE 128M REUSE AUTOEXTEND OFF;


------------------------------------------------------------------------------------------
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
PROMPT Creacion las FK nombre relacionado
PROMPT =================================================================================

ALTER TABLE Detalle_Factura ADD CONSTRAINT detalle_factura_fk_factura FOREIGN KEY (ID_factura) REFERENCES Encabezado(ID_factura);

ALTER TABLE Detalle_Factura ADD CONSTRAINT detalle_factura_fk_producto FOREIGN KEY (cod_producto) REFERENCES Productos(cod_producto);

ALTER TABLE Transacciones ADD CONSTRAINT transacciones_fk_cliente FOREIGN KEY (ID_cliente) REFERENCES Clientes(ID_cliente);

ALTER TABLE Transacciones ADD CONSTRAINT transacciones_fk_factura FOREIGN KEY (ID_factura) REFERENCES Encabezado(ID_factura);

------------------------------------------------------------------------------------------

PROMPT ===================================================================================
PROMPT  Insert Encabezado
PROMPT ===================================================================================
INSERT INTO Encabezado (ID_factura, fecha_factura, total_factura, correo) 
VALUES (1, TO_DATE('2023-07-12', 'YYYY-MM-DD'), 13699.98, 'blandonhillary162@gmail.com');

PROMPT ===================================================================================
PROMPT  Commit para Encabezado
PROMPT ===================================================================================
COMMIT;

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
COMMIT;

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

------------------------------------------------------------------------------------------

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
PROMPT  Fin del codigo.
PROMPT ===================================================================================

