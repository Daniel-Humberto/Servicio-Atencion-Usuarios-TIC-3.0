    -- Creación de la base de datos
    CREATE DATABASE IF NOT EXISTS `ModuloAtencionUsuariosV3`;
    USE `ModuloAtencionUsuariosV3`;


    -- Tabla de Usuarios
    CREATE TABLE Usuarios (
        IDUsuario INT PRIMARY KEY AUTO_INCREMENT,
        ID VARCHAR(100) NOT NULL,
        Nombre VARCHAR(100) NOT NULL,
        Unidad VARCHAR(100),
        SubUnidad VARCHAR(100)
    );


    -- Tabla de TipoUsuario 
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


    -- Tabla de Administrador
    CREATE TABLE Administrador (
        IDAdministrador INT PRIMARY KEY AUTO_INCREMENT,
        IDUsuario INT NOT NULL,
        CONSTRAINT FK_Administrador_Usuario FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
    );


    -- Administrador-Proceso
    CREATE TABLE Administrador_Proceso (
        IDAdministrador INT NOT NULL,
        IDProceso INT NOT NULL,
        PRIMARY KEY (IDAdministrador, IDProceso),
        CONSTRAINT FK_AdministradorProceso_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE CASCADE,
        CONSTRAINT FK_AdministradorProceso_Proceso FOREIGN KEY (IDProceso) REFERENCES Procesos(IDProceso) ON DELETE CASCADE
    );


    -- Administrador-Servicio
    CREATE TABLE Administrador_Servicio (
        IDAdministrador INT NOT NULL,
        IDServicio INT NOT NULL,
        PRIMARY KEY (IDAdministrador, IDServicio),
        CONSTRAINT FK_AdministradorServicio_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE CASCADE,
        CONSTRAINT FK_AdministradorServicio_Servicio FOREIGN KEY (IDServicio) REFERENCES Servicios(IDServicio) ON DELETE CASCADE
    );


    -- Administrador-Infraestructura
    CREATE TABLE Administrador_Infraestructura (
        IDAdministrador INT NOT NULL,
        IDInfraestructura INT NOT NULL,
        PRIMARY KEY (IDAdministrador, IDInfraestructura),
        CONSTRAINT FK_AdministradorInfraestructura_Administrador FOREIGN KEY (IDAdministrador) REFERENCES Administrador(IDAdministrador) ON DELETE CASCADE,
        CONSTRAINT FK_AdministradorInfraestructura_Infraestructura FOREIGN KEY (IDInfraestructura) REFERENCES Infraestructura(IDInfraestructura) ON DELETE CASCADE
    );


    -- Tabla de Permisos 
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


    -- Tabla de Procesos
    CREATE TABLE Procesos (
        IDProceso INT PRIMARY KEY AUTO_INCREMENT,
        IDPermiso INT UNIQUE, 
        Nombre VARCHAR(100) NOT NULL,
        Descripcion TEXT,
        TipoUsuario VARCHAR(50) NOT NULL,
        CONSTRAINT FK_Proceso_Permiso FOREIGN KEY (IDPermiso) REFERENCES Permisos(IDPermiso)
    );


    -- Tabla de Servicios / Procedimientos
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


    -- Tabla de Infraestructura
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


    -- Tabla de Servicio-Infraestructura
    CREATE TABLE Servicio_Infraestructura (
        IDServicio INT NOT NULL,
        IDInfraestructura INT NOT NULL,
        PRIMARY KEY (IDServicio, IDInfraestructura),
        CONSTRAINT FK_ServicioInfraestructura_Servicio FOREIGN KEY (IDServicio) REFERENCES Servicios(IDServicio) ON DELETE CASCADE ON UPDATE CASCADE,
        CONSTRAINT FK_ServicioInfraestructura_Infraestructura FOREIGN KEY (IDInfraestructura) REFERENCES Infraestructura(IDInfraestructura) ON DELETE CASCADE ON UPDATE CASCADE
    );


    -- Tabla de Tickets
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


    -- Tabla de ChatTicket
    CREATE TABLE ChatTicket (
        IDChatTicket INT PRIMARY KEY AUTO_INCREMENT,
        IDTicket INT NOT NULL,
        IDUsuario INT NOT NULL,
        Texto TEXT NOT NULL,
        Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT FK_ChatTicket_Ticket FOREIGN KEY (IDTicket) REFERENCES Tickets(IDTicket),
        CONSTRAINT FK_ChatTicket_Usuario FOREIGN KEY (IDUsuario) REFERENCES Usuarios(IDUsuario)
    );


    -- Tabla de EncuestaSatisfaccion
    CREATE TABLE EncuestaSatisfaccion (
        IDEncuesta INT PRIMARY KEY AUTO_INCREMENT,
        IDTicket INT NOT NULL,
        Respuesta1 ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
        Respuesta2 ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
        Respuesta3 ENUM ('Mal', 'Medio', 'Bien') NOT NULL,
        ComentariosAdicionales TEXT,
        CONSTRAINT FK_EncuestaSatisfaccion_Ticket FOREIGN KEY (IDTicket) REFERENCES Tickets(IDTicket)
    );


    -- Tabla de BuzonSugerencias
    CREATE TABLE BuzonSugerencias (
        IDSugerencia INT PRIMARY KEY AUTO_INCREMENT,
        Mensaje TEXT NOT NULL
    );