CREATE DATABASE IF NOT EXISTS `AgendaAmbiental`;
USE `AgendaAmbiental`;


-- Tabla de TipoUsuarios
CREATE TABLE `TipoUsuarios` (
    `IDTipoUsuario` INT PRIMARY KEY AUTO_INCREMENT,
    `TipoUsuario` ENUM(
        'Super Usuario', 'UASLP', 'Colaborador', 'Externo', 
        'Agenda Ambiental', 'Alta dirección', 
        'Eje o Proceso Lider', 'Eje o Proceso Apoyo'
    ) NOT NULL
);


-- Tabla de Usuarios  
CREATE TABLE `Usuarios` (
    `IDUsuario` INT PRIMARY KEY AUTO_INCREMENT,
    `IDTipoUsuario` INT NOT NULL,
    `RPE` INT NOT NULL UNIQUE,
    `Nombre` VARCHAR(50) NOT NULL,
    `Apellido` VARCHAR(50) NOT NULL,
    `Telefono` VARCHAR(15),
    `Correo` VARCHAR(100) UNIQUE NOT NULL,
    `Unidad` VARCHAR(100),
    `SubUnidad` VARCHAR(100),
    CONSTRAINT `FK_Usuarios_TipoUsuarios` FOREIGN KEY (`IDTipoUsuario`) REFERENCES `TipoUsuarios`(`IDTipoUsuario`) 
);


-- Tabla de Procesos
CREATE TABLE `Procesos` (
    `IDProceso` INT PRIMARY KEY AUTO_INCREMENT,
    `Nombre` VARCHAR(100) NOT NULL,
    `Descripcion` TEXT,
    `Categoria` VARCHAR(50) NOT NULL
);


-- Tabla de Servicios
CREATE TABLE `Servicios` (
    `IDServicio` INT PRIMARY KEY AUTO_INCREMENT,
    `IDProceso` INT, 
    `Nombre` VARCHAR(100) NOT NULL,
    `Descripcion` TEXT,
    `Categoria` VARCHAR(50) NOT NULL,
    CONSTRAINT `FK_Servicios_Procesos` FOREIGN KEY (`IDProceso`) REFERENCES `Procesos`(`IDProceso`) 
);


-- Tabla de Productos
CREATE TABLE `Productos` (
    `IDProducto` INT PRIMARY KEY AUTO_INCREMENT,
    `IDServicio` INT, 
    `Nombre` VARCHAR(100) NOT NULL,
    `Descripcion` TEXT,
    `Categoria` VARCHAR(50) NOT NULL,
    `Precio` DECIMAL(10,2) NOT NULL,
    `Fecha_Adquirido` DATE NOT NULL,
    `Estatus` ENUM('Disponible', 'No Disponible', 'En Reparación') NOT NULL,
    `Detalles_Estatus` TEXT,
    CONSTRAINT `FK_Productos_Servicios` FOREIGN KEY (`IDServicio`) REFERENCES `Servicios`(`IDServicio`) 
);


-- Tabla de Tickets
CREATE TABLE `Tickets` (
    `IDTicket` INT PRIMARY KEY AUTO_INCREMENT,
    `IDUsuario` INT NOT NULL,
    `IDServicio` INT NOT NULL,
    `Asunto` VARCHAR(200) NOT NULL,
    `Detalle_Solicitud` TEXT NOT NULL,
    `Fecha_Creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `Fecha_Cierre` DATETIME,
    `Estatus_User` ENUM ('EnProceso', 'Cerrado', 'Pendiente') NOT NULL,
    `Estatus_Admin` ENUM ('Pendiente', 'En Proceso', 'Finalizado') NOT NULL,
    CONSTRAINT `FK_Tickets_Usuarios` FOREIGN KEY (`IDUsuario`) REFERENCES `Usuarios`(`IDUsuario`), -- 👈 Se agregó coma
    CONSTRAINT `FK_Tickets_Servicios` FOREIGN KEY (`IDServicio`) REFERENCES `Servicios`(`IDServicio`)
);


-- Tabla de ChatTicket
CREATE TABLE `ChatTicket` (
    `IDChatTicket` INT PRIMARY KEY AUTO_INCREMENT,
    `IDTicket` INT NOT NULL,
    `IDUsuario` INT NOT NULL,
    `Texto` TEXT NOT NULL,
    `Fecha` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `FK_ChatTicket_Tickets` FOREIGN KEY (`IDTicket`) REFERENCES `Tickets`(`IDTicket`), -- 👈 Se agregó coma
    CONSTRAINT `FK_ChatTicket_Usuarios` FOREIGN KEY (`IDUsuario`) REFERENCES `Usuarios`(`IDUsuario`)
);


-- Tabla de EncuestaSatisfaccion
CREATE TABLE `EncuestaSatisfaccion` (
    `IDEncuesta` INT PRIMARY KEY AUTO_INCREMENT,
    `IDTicket` INT NOT NULL,
    `Respuesta1` ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
    `Respuesta2` ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
    `Respuesta3` ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
    `ComentariosAdicionales` TEXT,
    CONSTRAINT `FK_EncuestaSatisfaccion_Tickets` FOREIGN KEY (`IDTicket`) REFERENCES `Tickets`(`IDTicket`)
);


-- Tabla de BuzonSugerencias
CREATE TABLE `BuzonSugerencias` (
    `IDSugerencia` INT PRIMARY KEY AUTO_INCREMENT,
    `Mensaje` TEXT NOT NULL
);


(Procesos/Servicios, Servicios/Productos)