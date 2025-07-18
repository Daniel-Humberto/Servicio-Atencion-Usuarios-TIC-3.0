-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS `ModuloAtencionUsuariosV3`;
USE `ModuloAtencionUsuariosV3`;


-- 1. Tabla de Usuarios
CREATE TABLE Usuarios (
    IDUsuario INT PRIMARY KEY AUTO_INCREMENT,
    ID VARCHAR(100) NOT NULL,
    Nombre VARCHAR(100) NOT NULL,
    Unidad VARCHAR(100),
    SubUnidad VARCHAR(100)
);


-- 2. Tabla de Permisos
CREATE TABLE Permisos (
    IDPermiso INT PRIMARY KEY AUTO_INCREMENT,
    SuperUsuario BOOLEAN NOT NULL DEFAULT FALSE,
    UASLP BOOLEAN NOT NULL DEFAULT TRUE,
    Colaborador BOOLEAN NOT NULL DEFAULT FALSE,
    Externo BOOLEAN NOT NULL DEFAULT FALSE,
    AgendaAmbiental BOOLEAN NOT NULL DEFAULT FALSE,
    AltaDireccion BOOLEAN NOT NULL DEFAULT FALSE,
    EjeProcesoLider BOOLEAN NOT NULL DEFAULT FALSE,
    EjeProcesoApoyo BOOLEAN NOT NULL DEFAULT FALSE
);


-- 3. Tabla de TipoUsuario (depende de Usuarios)
CREATE TABLE TipoUsuario (
    IDTipoUsuario INT PRIMARY KEY AUTO_INCREMENT,
    IDUsuario INT UNIQUE, 
    SuperUsuario BOOLEAN NOT NULL DEFAULT FALSE,
    UASLP BOOLEAN NOT NULL DEFAULT TRUE,
    Colaborador BOOLEAN NOT NULL DEFAULT FALSE,
    Externo BOOLEAN NOT NULL DEFAULT FALSE,
    AgendaAmbiental BOOLEAN NOT NULL DEFAULT FALSE,
    AltaDireccion BOOLEAN NOT NULL DEFAULT FALSE,
    EjeProcesoLider BOOLEAN NOT NULL DEFAULT FALSE,
    EjeProcesoApoyo BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT FK_TipoUsuario_Usuario FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
);


-- 4. Tabla de Procesos (depende de Permisos)
CREATE TABLE Procesos (
    IDProceso INT PRIMARY KEY AUTO_INCREMENT,
    IDPermiso INT UNIQUE, 
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    TipoUsuario VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Proceso_Permiso FOREIGN KEY (IDPermiso) REFERENCES Permisos(IDPermiso)
);


-- 5. Tabla de Infraestructura (depende de Permisos)
CREATE TABLE Infraestructura (
    IDInfraestructura INT PRIMARY KEY AUTO_INCREMENT,
    IDPermiso INT UNIQUE,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Categoria ENUM('Hardware', 'Software', 'Instalaciones') NOT NULL,
    Precio DECIMAL(10,2),
    Fecha_Adquirido DATE NOT NULL,
    Estatus ENUM('Disponible', 'No Disponible', 'En Reparación') NOT NULL,
    Detalles_Estatus TEXT,
    CONSTRAINT FK_Infraestructura_Permiso FOREIGN KEY (IDPermiso) REFERENCES Permisos(IDPermiso)
);


-- 6. Tabla de Servicios (depende de Procesos y Permisos)
CREATE TABLE Servicios (
    IDServicio INT PRIMARY KEY AUTO_INCREMENT,
    IDProceso INT NOT NULL,
    IDPermiso INT UNIQUE,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    TipoUsuario VARCHAR(50) NOT NULL,
    CONSTRAINT FK_Servicio_Proceso FOREIGN KEY (IDProceso) REFERENCES Procesos(IDProceso) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Servicio_Permiso FOREIGN KEY (IDPermiso) REFERENCES Permisos(IDPermiso)
);


-- 7. Tabla de Administrador (depende de Usuarios)
CREATE TABLE Administrador (
    IDAdministrador INT PRIMARY KEY AUTO_INCREMENT,
    IDUsuario INT NOT NULL,
    CONSTRAINT FK_Administrador_Usuario FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
);


-- 8. Tabla Administrador_Proceso (depende de Administrador y Procesos)
CREATE TABLE Administrador_Proceso (
    IDAdministrador INT NOT NULL,
    IDProceso INT NOT NULL,
    PRIMARY KEY (IDAdministrador, IDProceso),
    CONSTRAINT FK_AdministradorProceso_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE CASCADE,
    CONSTRAINT FK_AdministradorProceso_Proceso FOREIGN KEY (IDProceso) REFERENCES Procesos(IDProceso) ON DELETE CASCADE
);


-- 9. Tabla Administrador_Servicio (depende de Administrador y Servicios)
CREATE TABLE Administrador_Servicio (
    IDAdministrador INT NOT NULL,
    IDServicio INT NOT NULL,
    PRIMARY KEY (IDAdministrador, IDServicio),
    CONSTRAINT FK_AdministradorServicio_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE CASCADE,
    CONSTRAINT FK_AdministradorServicio_Servicio FOREIGN KEY (IDServicio) REFERENCES Servicios(IDServicio) ON DELETE CASCADE
);


-- 10. Tabla Administrador_Infraestructura (depende de Administrador e Infraestructura)
CREATE TABLE Administrador_Infraestructura (
    IDAdministrador INT NOT NULL,
    IDInfraestructura INT NOT NULL,
    PRIMARY KEY (IDAdministrador, IDInfraestructura),
    CONSTRAINT FK_AdministradorInfraestructura_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE CASCADE,
    CONSTRAINT FK_AdministradorInfraestructura_Infraestructura FOREIGN KEY (IDInfraestructura) REFERENCES Infraestructura(IDInfraestructura) ON DELETE CASCADE
);


-- 11. Tabla Servicio_Infraestructura (depende de Servicios e Infraestructura)
CREATE TABLE Servicio_Infraestructura (
    IDServicio INT NOT NULL,
    IDInfraestructura INT NOT NULL,
    PRIMARY KEY (IDServicio, IDInfraestructura),
    CONSTRAINT FK_ServicioInfraestructura_Servicio FOREIGN KEY (IDServicio) REFERENCES Servicios(IDServicio) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_ServicioInfraestructura_Infraestructura FOREIGN KEY (IDInfraestructura) REFERENCES Infraestructura(IDInfraestructura) ON DELETE CASCADE ON UPDATE CASCADE
);  


-- 12. Tabla Tickets (depende de Usuarios, Administrador, Procesos, Servicios, Infraestructura)
CREATE TABLE Tickets (
    IDTicket INT PRIMARY KEY AUTO_INCREMENT,
    IDUsuario INT NOT NULL,
    IDAdministrador INT,
    IDProceso INT,
    IDServicio INT,
    IDInfraestructura INT,
    Asunto VARCHAR(200) NOT NULL,
    Detalle_Solicitud TEXT NOT NULL,
    Fecha_Creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    Fecha_Cierre DATETIME,
    Estatus_User ENUM ('Pendiente', 'En Proceso', 'Finalizado') NOT NULL,
    Estatus_Admin ENUM ('Pendiente', 'En Proceso', 'Finalizado') NOT NULL,
    CONSTRAINT FK_Ticket_Usuario FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_Ticket_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Ticket_Proceso FOREIGN KEY (IDProceso) REFERENCES Procesos(IDProceso) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Ticket_Servicio FOREIGN KEY (IDServicio) REFERENCES Servicios(IDServicio) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_Ticket_Infraestructura FOREIGN KEY (IDInfraestructura) REFERENCES Infraestructura(IDInfraestructura) ON DELETE SET NULL ON UPDATE CASCADE
);


-- 13. Tabla ChatTicket (depende de Tickets y Usuarios)
CREATE TABLE ChatTicket (
    IDChatTicket INT PRIMARY KEY AUTO_INCREMENT,
    IDTicket INT NOT NULL,
    IDUsuario INT NOT NULL,
    Texto TEXT NOT NULL,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_ChatTicket_Ticket FOREIGN KEY (IDTicket) REFERENCES Tickets(IDTicket),
    CONSTRAINT FK_ChatTicket_Usuario FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
);


-- 14. Tabla EncuestaSatisfaccion (depende de Tickets)
CREATE TABLE EncuestaSatisfaccion (
    IDEncuesta INT PRIMARY KEY AUTO_INCREMENT,
    IDTicket INT NOT NULL,
    Respuesta1 ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
    Respuesta2 ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
    Respuesta3 ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
    ComentariosAdicionales TEXT,
    CONSTRAINT FK_EncuestaSatisfaccion_Ticket FOREIGN KEY (IDTicket) REFERENCES Tickets(IDTicket)
);


-- 15. Tabla BuzonSugerencias (independiente)
CREATE TABLE BuzonSugerencias (
    IDSugerencia INT PRIMARY KEY AUTO_INCREMENT,
    Mensaje TEXT NOT NULL
);