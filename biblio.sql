USE MASTER
CREATE DATABASE BIBLIOTERCA_DB
go

USE  BIBLIOTERCA_DB
GO
CREATE TABLE TB_ADMIN  (
ID_ADMIN INT NOT NULL PRIMARY KEY, 
NOM_ADMIN VARCHAR(20)  NOT NULL, 
AP_ADMIN VARCHAR(30) NOT NULL, 
CEL_ADMIN  INT, 
CORREO_ADMIN VARCHAR(60),
CONT_ADMIN VARCHAR(65) NOT NULL  
)
GO


USE BIBLIOTERCA_DB
GO
CREATE TABLE TB_VENDEDOR 
(ID_VEND INT NOT NULL PRIMARY KEY,
NOM_VEND VARCHAR (20) NOT NULL, 
AP_VEND VARCHAR (30) NOT NULL, 
CEL_VEND INT, 
CORREO_VEND VARCHAR (60), 
CONT_VEND VARCHAR(65) NOT NULL
)
GO

---clientes 
---añadir 2 más
USE BIBLIOTERCA_DB
GO 

CREATE TABLE TB_CLIENTE
(ID_CLIENT INT NOT NULL  PRIMARY KEY,
NOM_CLIENT VARCHAR(30) NOT NULL, 
AP_CLIENT VARCHAR(60) NOT NULL, 
CEL_CLIENT INT NOT NULL, 
CORREO VARCHAR(80) NOT NULL, 
CONT_CLIENT VARCHAR(30) NOT NULL,
DIR_CLIENT VARCHAR (50)
)
GO


USE BIBLIOTERCA_DB
GO 

CREATE TABLE TB_LIBRO    ----CONSIDERAR EDITORIAL  XD
(ID_LIBRO VARCHAR (10) NOT NULL PRIMARY KEY, 
TIT_LIBRO VARCHAR (60) NOT NULL, 
EDIT VARCHAR(60) NOT NULL,
AUT_LIBRO VARCHAR (50) NOT NULL,
PREC_LIBRO DECIMAL NOT NULL, 
STOCK_LIBRO INT)
GO

---Revisar la boleta para trabajar con sp y cómo seria XD
 
USE BIBLIOTERCA_DB   
GO 
CREATE TABLE TB_BOLETA
(ID_BOLETA   VARCHAR (8) NOT NULL PRIMARY KEY, 
ID_VEND INT  FOREIGN KEY REFERENCES TB_VENDEDOR(ID_VEND) NOT NULL,
ID_CLIENT INT FOREIGN KEY REFERENCES TB_CLIENTE (ID_CLIENT) NOT NULL,
ID_LIBRO VARCHAR(10) FOREIGN KEY REFERENCES TB_LIBRO (ID_LIBRO) NOT NULL, 
CANT_LIBRO INT NOT NULL, 
COSTO_TOTAL DECIMAL  NOT NULL,
FECHORA_BOL  SMALLDATETIME default GETDATE()
);
GO
 


 ---- VER TABLAS 

SELECT * FROM TB_ADMIN 
SELECT * FROM TB_BOLETA
SELECT * FROM TB_CLIENTE
SELECT * FROM  TB_LIBRO
SELECT * FROM  TB_VENDEDOR


 --- DROPEO 

DROP TABLE TB_ADMIN
DROP TABLE TB_BOLETA
DROP TABLE TB_CLIENTE
DROP TABLE TB_LIBRO
DROP TABLE TB_VENDEDOR


---DROPEAR MI DB
USE MASTER
GO
DROP DATABASE BIBLIOTERCA_DB
----

INSERT INTO TB_ADMIN 
values
(45673200, 'Ada' , 'Flores Castillo', 980087653,'aflores@btc.com', 'ADMIN')

INSERT INTO TB_CLIENTE 
values
(23415432, 'Daniel', 'Paz Julca', 23456778, 'dani_paz@yimeil.com','DANIEL', 'Av.Universitaria 809')

INSERT INTO TB_VENDEDOR 
values
(30984570, 'Paulo' , 'Barrera Quispe', 945673213,'pbarrera@btc.com', 'Vendedor') 

INSERT INTO TB_VENDEDOR 
values
(45673289, 'Hermelinda' , 'Guevara Soto', 945673213,'hguevara@btc.com', 'Vendedora') -- corregir contra del vendedor xd has puesto admin


INSERT INTO TB_LIBRO 
values 
('L001', 'La ciudad y los perros', 'Alfaguara',  'Mario Vargas Llosa', 20.00, 10) --- corregir precios xd muy altos

INSERT INTO TB_LIBRO 
values 
('L002', 'Edipo rey',  'Amazonas', 'Sófocles', 10.00, 10)

INSERT INTO TB_LIBRO 
values 
('L003', 'Álgebra básica', 'vicens-vivens', 'Michel Queysanne', 18.00, 10)


-----------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------
--procedimiento almacenado 

----Procedimiento almacenado Vendedores

USE BIBLIOTERCA_DB  
GO

CREATE PROCEDURE Usp_listaVendedores
As
select * from TB_VENDEDOR 




-- Llamar al procedimiento almacenado para insertar una boleta
EXEC SP_InsertBoleta @ID_VEND = 1, @ID_CLIENT = 1, @ID_LIBRO = 'L001', @CANT_LIBRO = 2, @ID_BOLETA = 'B00001';
USE BIBLIOTERCA_DB;
GO

 
CREATE PROCEDURE SP_InsertBoleta
    @ID_VEND INT,
    @ID_CLIENT INT,
    @ID_LIBRO VARCHAR(10),
    @CANT_LIBRO INT,
    @ID_BOLETA VARCHAR(8)
AS
BEGIN
    DECLARE @PREC_LIBRO DECIMAL(10, 2);
    
    -- Obtener el precio del libro
    SELECT @PREC_LIBRO = PREC_LIBRO FROM TB_LIBRO WHERE ID_LIBRO = @ID_LIBRO;

    -- Calcular el costo total
    DECLARE @COSTO_TOTAL DECIMAL(10, 2);
    SET @COSTO_TOTAL = @CANT_LIBRO * @PREC_LIBRO;

    -- Insertar en TB_BOLETA
    INSERT INTO TB_BOLETA (ID_BOLETA, ID_VEND, ID_CLIENT, ID_LIBRO, CANT_LIBRO, FECHA_PED, COSTO_TOTAL)
    VALUES (@ID_BOLETA, @ID_VEND, @ID_CLIENT, @ID_LIBRO, @CANT_LIBRO, GETDATE(), @COSTO_TOTAL);
END;
GO


---- Considerar realizar unas tablas  para autores o editoriales  o solo tomarlos como atributos de los libros 
----- trabajar uso de desplegable (combo box)


----CRUD VENDEDORES-----------------------------

USE BIBLIOTERCA_DB 
GO 
---------- no es necesario 
CREATE PROCEDURE usp_listaVendedores 
As
Select * from TB_VENDEDORES
Go
-------------------------CRUD DE VENDEDORES

Create procedure usp_addVendedores 
@ID_VEND   INT, 
@NOM_VEND VARCHAR (20),
@AP_VEND VARCHAR (30),
@CEL_VEND  INT, 
@CORREO_VEND  VARCHAR (60),
@CONT_VEND  VARCHAR (65)
As
insert into TB_VENDEDOR
Values (@ID_VEND, @NOM_VEND, @AP_VEND, @CEL_VEND, @CORREO_VEND, @CONT_VEND);
GO



Create procedure usp_updateVendedores 
@ID_VEND   INT, 
@NOM_VEND VARCHAR (20),
@AP_VEND VARCHAR (30),
@CEL_VEND  INT, 
@CORREO_VEND  VARCHAR (60),
@CONT_VEND  VARCHAR (65)
As
Update TB_VENDEDOR
Set  ID_VEND = @ID_VEND, NOM_VEND = @NOM_VEND, AP_VEND = @AP_VEND, CEL_VEND =@CEL_VEND, CORREO_VEND= @CORREO_VEND, CONT_VEND = @CONT_VEND
where ID_VEND = @ID_VEND;

GO


SELECT * FROM TB_VENDEDOR

Create procedure usp_deleteVendedores 
@ID_VEND   INT
As
delete TB_VENDEDORES 
where ID_VEND=@ID_VEND;
GO


--------------------------------



---DROPEAR PROCEDIMIENTOS ALMACENADOS
DROP PROCEDURE [usp_addVendedores];
GO


----------------------------------------------



CREATE TABLE TB_VENDEDOR 
(ID_VEND INT NOT NULL PRIMARY KEY,
NOM_VEND VARCHAR (20) NOT NULL, 
AP_VEND VARCHAR (30) NOT NULL, 
CEL_VEND INT, 
CORREO_VEND VARCHAR (60), 
CONT_VEND VARCHAR(65) NOT NULL
)
GO

-----------------

USE BIBLIOTERCA_DB
GO
DROP TABLE USUARIO
GO 

CREATE TABLE USUARIO (
IdUsuario int primary key identity (1, 1),
Correo varchar (100),
Clave varchar (500)
)
-----------------------------------

DROP PROCEDURE [sp_RegistrarUsuario];
GO
----------------------------------------
create proc sp_RegistrarUsuario(
@Correo varchar (100), 
@Clave varchar (500),
@Registrado bit output,
@Mensaje varchar (100) output
)
as
begin

if(not exists (select * from USUARIO where Correo = @Correo))
begin
		insert into USUARIO(Correo, Clave) values (@Correo, @Clave)
		set @Registrado = 1
		set @Mensaje = 'usuario registrado'
	end 
	else
	begin
		 set @Registrado = 0
		 set @Mensaje = 'correo ya existe'

	 end
end 

-----------------------

create proc sp_ValidarUsuario (
@Correo varchar(100),
@Clave varchar (500)
)
as
begin
	if(exists (select * from  USUARIO where Correo = @Correo and Clave = @Clave))
		select IdUsuario from USUARIO where Correo = @Correo and Clave = @Clave 
else 
	select '0'

end 

------------------------------------------------------------

	declare @registrado bit, @mensaje varchar(100)
	exec sp_RegistrarUsuario 'melyn@yimeil.com', 'ee682dcf56193bb7bbf3f2eb1c26aa3c632293e72254c294ed53a831c583ea9c', @registrado output, @mensaje output 
	select @registrado
	select @mensaje

	exec sp_ValidarUsuario  'melyn@yimeil.com', 'ee682dcf56193bb7bbf3f2eb1c26aa3c632293e72254c294ed53a831c583ea9c'


	select * from USUARIO







