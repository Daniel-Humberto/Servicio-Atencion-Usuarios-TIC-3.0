CREATE TABLE `TipoUsuarios` (
  `IDTipoUsuario` INT PRIMARY KEY AUTO_INCREMENT,
  `Nombre` VARCHAR(50) NOT NULL,
  `Privilegios` TEXT NOT NULL
);

CREATE TABLE `Usuarios` (
  `IDUsuario` INT PRIMARY KEY AUTO_INCREMENT,
  `IDTipoUsuario` INT NOT NULL,
  `RPE` VARCHAR(20) UNIQUE NOT NULL,
  `Nombre` VARCHAR(50) NOT NULL,
  `Apellido` VARCHAR(50) NOT NULL,
  `Telefono` VARCHAR(15),
  `Correo` VARCHAR(100) UNIQUE NOT NULL,
  `Unidad` VARCHAR(100),
  `SubUnidad` VARCHAR(100)
);

CREATE TABLE `Servicios` (
  `IDServicio` INT PRIMARY KEY AUTO_INCREMENT,
  `Nombre` VARCHAR(100) NOT NULL,
  `Descripcion` TEXT,
  `Categoria` VARCHAR(50) NOT NULL
);

CREATE TABLE `Productos` (
  `IDProducto` INT PRIMARY KEY AUTO_INCREMENT,
  `Nombre` VARCHAR(100) NOT NULL,
  `Descripcion` TEXT,
  `Categoria` VARCHAR(50) NOT NULL,
  `Precio` DECIMAL(10,2) NOT NULL,
  `Fecha_Adquirido` DATE NOT NULL,
  `Estatus` ENUM ('Disponible', 'No Disponible', 'En Reparación') NOT NULL,
  `Detalles_Estatus` TEXT
);

CREATE TABLE `Tickets` (
  `IDTicket` INT PRIMARY KEY AUTO_INCREMENT,
  `IDUsuario` INT NOT NULL,
  `IDServicio` INT,
  `IDProducto` INT,
  `Nombre` VARCHAR(50) NOT NULL,
  `Apellido` VARCHAR(50) NOT NULL,
  `Telefono` VARCHAR(15),
  `Correo` VARCHAR(100) NOT NULL,
  `Unidad` VARCHAR(100),
  `SubUnidad` VARCHAR(100),
  `Proceso` VARCHAR(50) NOT NULL,
  `Servicio` VARCHAR(100) NOT NULL,
  `Asunto` VARCHAR(200) NOT NULL,
  `Detalle_Solicitud` TEXT NOT NULL,
  `Fecha_Creacion` DATETIME DEFAULT (CURRENT_TIMESTAMP),
  `Fecha_Cierre` DATETIME,
  `Estatus_User` ENUM ('Abierto', 'Cerrado', 'Pendiente') NOT NULL,
  `Estatus_Admin` ENUM ('Pendiente', 'En Proceso', 'Finalizado') NOT NULL
);

CREATE TABLE `EncuestaSatisfaccion` (
  `IDEncuesta` INT PRIMARY KEY AUTO_INCREMENT,
  `IDTicket` INT NOT NULL,
  `Pregunta1` VARCHAR(255) NOT NULL,
  `Respuesta1` TEXT NOT NULL,
  `Pregunta2` VARCHAR(255) NOT NULL,
  `Respuesta2` TEXT NOT NULL,
  `Pregunta3` VARCHAR(255) NOT NULL,
  `Respuesta3` TEXT NOT NULL
);

CREATE TABLE `BuzonSugerencias` (
  `IDSugerencia` INT PRIMARY KEY AUTO_INCREMENT,
  `Mensaje` TEXT NOT NULL
);

ALTER TABLE `Usuarios` ADD FOREIGN KEY (`IDTipoUsuario`) REFERENCES `TipoUsuarios` (`IDTipoUsuario`);

ALTER TABLE `Tickets` ADD FOREIGN KEY (`IDUsuario`) REFERENCES `Usuarios` (`IDUsuario`);

ALTER TABLE `Tickets` ADD FOREIGN KEY (`IDServicio`) REFERENCES `Servicios` (`IDServicio`);

ALTER TABLE `Tickets` ADD FOREIGN KEY (`IDProducto`) REFERENCES `Productos` (`IDProducto`);

ALTER TABLE `EncuestaSatisfaccion` ADD FOREIGN KEY (`IDTicket`) REFERENCES `Tickets` (`IDTicket`);
