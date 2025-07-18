CREATE DATABASE IF NOT EXISTS `AgendaAmbiental`;
USE `AgendaAmbiental`;


-- Tabla de Usuarios 
CREATE TABLE `Usuarios` (
    `IDUsuario` INT PRIMARY KEY AUTO_INCREMENT,
    `TipoUsuario` ENUM('Super Usuario', 'UASLP', 'Colaborador', 'Externo', 'Agenda Ambiental', 'Alta dirección', 'Eje o Proceso Lider', 'Eje o Proceso Apoyo') NOT NULL,
    `Nombre` VARCHAR(100) NOT NULL,
    `Unidad` VARCHAR(100),
    `SubUnidad` VARCHAR(100)
);


-- Tabla de Infraestructura
CREATE TABLE `Infraestructura` (
    `IDInfraestructura` INT PRIMARY KEY AUTO_INCREMENT,
    `Nombre` VARCHAR(100) NOT NULL,
    `Descripcion` TEXT,
    `Categoria` ENUM('Hardware', 'Software', 'Red', 'Instalaciones', 'Servicios', 'Almacenamiento', 'Seguridad', 'Movilidad', 'Virtualización') NOT NULL,
    `Precio` DECIMAL(10,2),
    `Fecha_Adquirido` DATE NOT NULL,
    `Estatus` ENUM('Disponible', 'No Disponible', 'En Reparación') NOT NULL,
    `Detalles_Estatus` TEXT
);


-- Tabla de Procesos
CREATE TABLE `Procesos` (
    `IDProceso` INT PRIMARY KEY AUTO_INCREMENT,
    `Nombre` VARCHAR(100) NOT NULL,
    `Descripcion` TEXT,
    `TipoUsuario` VARCHAR(50) NOT NULL
);


-- Tabla de Servicios
CREATE TABLE `Servicios` (
    `IDServicio` INT PRIMARY KEY AUTO_INCREMENT,
    `IDProceso` INT,
    `IDInfraestructura` INT,
    `Nombre` VARCHAR(100) NOT NULL,
    `Descripcion` TEXT,
    `TipoUsuario` VARCHAR(50) NOT NULL,
    CONSTRAINT `FK_Servicios_Infraestructura` 
        FOREIGN KEY (`IDInfraestructura`) REFERENCES `Infraestructura`(`IDInfraestructura`) 
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT `FK_Servicios_Procesos` 
        FOREIGN KEY (`IDProceso`) REFERENCES `Procesos`(`IDProceso`) 
        ON DELETE SET NULL ON UPDATE CASCADE
);


-- Tabla de Tickets
CREATE TABLE `Tickets` (
    `IDTicket` INT PRIMARY KEY AUTO_INCREMENT,
    `IDUsuario` INT NOT NULL,
    `IDProceso` INT,
    `IDServicio` INT,
    `Asunto` VARCHAR(200) NOT NULL,
    `Detalle_Solicitud` TEXT NOT NULL,
    `Fecha_Creacion` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `Fecha_Cierre` DATETIME,
    `Estatus_User` ENUM ('EnProceso', 'Cerrado', 'Pendiente') NOT NULL,
    `Estatus_Admin` ENUM ('Pendiente', 'En Proceso', 'Finalizado') NOT NULL,
    CONSTRAINT `FK_Tickets_Usuarios` FOREIGN KEY (`IDUsuario`) REFERENCES `Usuarios`(`IDUsuario`)
);


-- Tabla de ChatTicket
CREATE TABLE `ChatTicket` (
    `IDChatTicket` INT PRIMARY KEY AUTO_INCREMENT,
    `IDTicket` INT NOT NULL,
    `IDUsuario` INT NOT NULL,
    `Texto` TEXT NOT NULL,
    `Fecha` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `FK_ChatTicket_Tickets` FOREIGN KEY (`IDTicket`) REFERENCES `Tickets`(`IDTicket`),
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