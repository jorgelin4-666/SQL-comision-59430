DROP DATABASE IF EXISTS  Muebleria;	
CREATE DATABASE Muebleria;
USE Muebleria;
CREATE TABLE Cliente (	
id_cliente INT NOT NULL auto_increment primary key,	
apellido VARCHAR (50) NOT NULL,
nombre VARCHAR (50) NOT NULL,
cuit VARCHAR (50),
domicilio VARCHAR (100) NOT NULL,
contacto VARCHAR (50) NOT NULL,
transporte ENUM ("porpio","flete")	
); 
CREATE TABLE Proveedor (	
id_proveedor INT NOT NULL auto_increment primary key,	
razon_social VARCHAR (50) NOT NULL,
nombre_fantasia VARCHAR (50),
CUIT VARCHAR (20) NOT NULL,
domicilio VARCHAR (50),	
ciudad VARCHAR (50),	
provincia VARCHAR (50),
contacto VARCHAR (50) NOT NULL,	
condicion_pago ENUM ("contado","15 días","30 días","45 días") NOT NULL,
transporte ENUM ("porpio","flete")
); 
CREATE TABLE Sector (	
id_sector INT NOT NULL auto_increment primary key,	
nombre VARCHAR (50)	NOT NULL
);	
CREATE TABLE Colaborador (	
id_colaborador INT NOT NULL auto_increment primary key,	
apellido VARCHAR (50) NOT NULL,
nombre VARCHAR (50) NOT NULL,
DNI VARCHAR (20),
domicilio VARCHAR (100),	
contacto VARCHAR (50) NOT NULL,	
pago_pactado VARCHAR (50) DEFAULT "a confirmar",
transporte ENUM ("porpio","flete"),
id_sector INT NOT NULL
); 
CREATE TABLE Empleado (	
id_empleado INT NOT NULL auto_increment primary key,	
apellido VARCHAR (50) NOT NULL,
nombre VARCHAR (50) NOT NULL,
CUIL VARCHAR (20) NOT NULL ,
domicilio VARCHAR (100),	
contacto VARCHAR (50) NOT NULL,	
fecha_ingreso DATE NOT NULL,
convenio VARCHAR (50),	
categoria VARCHAR (50),	
puesto VARCHAR (50),
jornada ENUM ("mañana","tarde","ambas"),
id_sector INT NOT NULL
); 
ALTER TABLE Empleado	
ADD CONSTRAINT FK_empleado_sector foreign key (id_sector)	
REFERENCES Muebleria.Sector (id_sector);	
ALTER TABLE Colaborador	
ADD CONSTRAINT FK_colaborador_sector foreign key (id_sector)	
REFERENCES Muebleria.Sector (id_sector);	

CREATE TABLE Medios_de_Cobro (	
id_cobro INT NOT NULL auto_increment primary key,	
tipo_cobro VARCHAR (50) NOT NULL,	
comision_vendedor DECIMAL (2,2)	DEFAULT 0
);
CREATE TABLE Categoria_Articulos (	
id_categoria INT NOT NULL auto_increment primary key,	
nombre VARCHAR (50) NOT NULL,	
id_sector INT NOT NULL
);
ALTER TABLE Categoria_Articulos	
ADD CONSTRAINT FK_categoria_sector foreign key (id_sector)	
REFERENCES Muebleria.Sector (id_sector);	

CREATE TABLE Articulo (	
id_articulo INT NOT NULL auto_increment primary key,	
nombre VARCHAR (50) NOT NULL,
descripcion_adic TEXT ,
unidad_de_medida VARCHAR (20) NOT NULL,
color VARCHAR (20) DEFAULT "no corresponde",	
id_categoria INT NOT NULL,	
id_proveedor INT NOT NULL	
);
ALTER TABLE Articulo	
ADD CONSTRAINT FK_articulo_categoria foreign key (id_categoria)	
REFERENCES Muebleria.Categoria_Articulos (id_categoria);	
ALTER TABLE Articulo	
ADD CONSTRAINT FK_articulo_proveedor foreign key (id_proveedor)	
REFERENCES Muebleria.Proveedor (id_proveedor);	

CREATE TABLE Categoria_Productos (	
id_categoria INT NOT NULL auto_increment primary key,	
nombre VARCHAR (50) NOT NULL,	
descripcion_adicional TEXT
);
CREATE TABLE Producto (	
id_producto INT NOT NULL auto_increment primary key,	
nombre VARCHAR (50) NOT NULL,
descripcion_adic TEXT ,
id_categoria INT NOT NULL
);
ALTER TABLE Producto
ADD CONSTRAINT FK_producto_categoria foreign key (id_categoria)	
REFERENCES Muebleria.Categoria_Productos (id_categoria);	  

CREATE TABLE Modelo (	
id_modelo INT NOT NULL auto_increment primary key,
nombre VARCHAR (50),
descripcion_adicional TEXT 	
);
  
CREATE TABLE Producto_Modelo (
id_produc_model INT NOT NULL auto_increment primary key,
id_producto INT NOT NULL,
id_modelo INT NOT NULL,
medida VARCHAR (50) NOT NULL DEFAULT "a confirmar",
metros_tela INT NOT NULL,
precio_lista DECIMAL (10,2) NOT NULL,
contado DECIMAL (10,2) DEFAULT 0,
pago_anticipado DECIMAL (10,2) DEFAULT 0	
); 
  
ALTER TABLE Producto_Modelo
ADD CONSTRAINT FK_Produc_Model_producto foreign key (id_producto)	
REFERENCES Muebleria.Producto (id_producto);
ALTER TABLE Producto_Modelo
ADD CONSTRAINT FK_Produc_Model_modelo foreign key (id_modelo)	
REFERENCES Muebleria.Modelo (id_modelo);

CREATE TABLE Venta (
id_venta INT NOT NULL auto_increment primary key,
fecha DATE NOT NULL,
id_cliente INT NOT NULL,
id_empleado INT NOT NULL,
dias_entrega INT NOT NULL,
id_cobro INT NOT NULL,
importe_total DECIMAL (10,2) NOT NULL,
seña DECIMAL (10,2) DEFAULT 0,
saldo DECIMAL (10,2) generated always AS (importe_total-seña)
); 
ALTER TABLE Venta
ADD CONSTRAINT FK_venta_cliente foreign key (id_cliente)	
REFERENCES Muebleria.Cliente (id_cliente);
ALTER TABLE Venta
ADD CONSTRAINT FK_venta_empleado foreign key (id_empleado)	
REFERENCES Muebleria.Empleado (id_empleado);
ALTER TABLE Venta
ADD CONSTRAINT FK_venta_cobro foreign key (id_cobro)	
REFERENCES Muebleria.Medios_de_Cobro (id_cobro);

CREATE TABLE Pedido (
id_pedido INT NOT NULL auto_increment primary key,
fecha DATE NOT NULL,
dias_entrega INT NOT NULL,
id_venta INT NOT NULL,
id_producto INT NOT NULL,
id_modelo INT NOT NULL,
medida VARCHAR (50) NOT NULL default "confirmar",
tela VARCHAR (100) NOT NULL default "confirmar",
lustre VARCHAR (20) NOT NULL default "confirmar",
descripcion_adicional TEXT,
cantidad INT NOT NULL,
precio_unitario DECIMAL (10,2) NOT NULL,
importe_total DECIMAL (10,2) generated always AS (cantidad * precio_unitario)
); 
ALTER TABLE Pedido
ADD CONSTRAINT FK_pedido_venta foreign key (id_venta)	
REFERENCES Muebleria.Venta (id_venta);
ALTER TABLE Pedido
ADD CONSTRAINT FK_pedido_producto foreign key (id_producto)	
REFERENCES Muebleria.Producto (id_producto);
ALTER TABLE Pedido
ADD CONSTRAINT FK_pedido_modelo foreign key (id_modelo)	
REFERENCES Muebleria.Modelo (id_modelo);

CREATE TABLE Orden_de_Compra (
id_orden_compra INT NOT NULL auto_increment primary key,
fecha DATE NOT NULL,
id_empleado INT NOT NULL,
id_pedido INT NOT NULL,
id_proveedor INT NOT NULL,
id_articulo INT NOT NULL,
descripcion_adicional VARCHAR (50),
cantidad INT NOT NULL,
precio_unitario DECIMAL (10,2) NOT NULL,
importe_total DECIMAL (10,2) generated always AS (cantidad * precio_unitario),
estado ENUM ("Recibido","Despachado","Pendiente")
); 
ALTER TABLE Orden_de_Compra
ADD CONSTRAINT FK_orden_empleado foreign key (id_empleado)	
REFERENCES Muebleria.Empleado (id_empleado);
ALTER TABLE Orden_de_Compra
ADD CONSTRAINT FK_orden_pedido foreign key (id_pedido)	
REFERENCES Muebleria.Pedido (id_pedido);
ALTER TABLE Orden_de_Compra
ADD CONSTRAINT FK_orden_proveedor foreign key (id_proveedor)	
REFERENCES Muebleria.Proveedor (id_proveedor);
ALTER TABLE Orden_de_Compra
ADD CONSTRAINT FK_orden_articulo foreign key (id_articulo)	
REFERENCES Muebleria.Articulo (id_articulo);

CREATE TABLE Orden_de_Trabajo (
id_trabajo INT NOT NULL auto_increment primary key,
fecha DATE NOT NULL,
id_pedido INT NOT NULL,
id_colaborador INT NOT NULL,
fecha_entrega DATE NOT NULL,
descripcion_adicional VARCHAR (50),
cantidad INT NOT NULL,
precio_pactado DECIMAL (10,2) NOT NULL,
importe_total DECIMAL (10,2) generated always AS (cantidad * precio_pactado),
estado ENUM ("Terminado","Produccion","Pendiente")
); 
ALTER TABLE Orden_de_Trabajo
ADD CONSTRAINT FK_trabajo_pedido foreign key (id_pedido)	
REFERENCES Muebleria.Pedido (id_pedido);
ALTER TABLE Orden_de_Trabajo
ADD CONSTRAINT FK_trabajo_colaborador foreign key (id_colaborador)	
REFERENCES Muebleria.Colaborador (id_colaborador);
