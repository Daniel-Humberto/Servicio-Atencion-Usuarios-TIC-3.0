USE `ModuloAtencionUsuariosV3`;

-- =========================================
-- 1. Insertar Usuarios
-- =========================================
INSERT INTO Usuarios (ID, Nombre, Unidad, SubUnidad) VALUES
('USR001', 'Ana García',      'TI',        'Soporte'),
('USR002', 'Luis Martínez',   'Finanzas',  'Contabilidad'),
('USR003', 'María López',     'Ambiental', 'Agenda Ambiental'),
('USR004', 'Carlos Pérez',    'Dirección', 'Alta Dirección'),
('USR005', 'Sofía Hernández', 'Operaciones','Proceso');

-- =========================================
-- 2. Insertar Permisos
-- =========================================
INSERT INTO Permisos (SuperUsuario, UASLP, Colaborador, Externo, AgendaAmbiental, AltaDireccion, EjeProcesoLider, EjeProcesoApoyo) VALUES
-- Para Ana (soporte TI)
(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE),
-- Para Luis (finanzas)
(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE),
-- Para María (agenda ambiental)
(FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE),
-- Para Carlos (alta dirección)
(TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE),
-- Para Sofía (operaciones)
(FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE);

-- =========================================
-- 3. Insertar TipoUsuario (mismos valores que Permisos)
-- =========================================
INSERT INTO TipoUsuario (IDUsuario, SuperUsuario, UASLP, Colaborador, Externo, AgendaAmbiental, AltaDireccion, EjeProcesoLider, EjeProcesoApoyo) VALUES
(1, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE),
(2, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE),
(3, FALSE, TRUE, FALSE, FALSE, TRUE, FALSE, FALSE, FALSE),
(4, TRUE, TRUE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE),
(5, FALSE, TRUE, TRUE, FALSE, FALSE, FALSE, FALSE, TRUE);

-- =========================================
-- 4. Insertar Procesos
-- =========================================
INSERT INTO Procesos (IDPermiso, Nombre, Descripcion, TipoUsuario) VALUES
(2, 'Apertura de ticket',      'Proceso de registro de nuevos tickets',    'Colaborador'),
(3, 'Revisión ambiental',      'Tramitar permisos de impacto ambiental',    'AgendaAmbiental'),
(4, 'Decisión ejecutiva',      'Aprobación por alta dirección',            'AltaDireccion');

-- =========================================
-- 5. Insertar Infraestructura
-- =========================================
INSERT INTO Infraestructura (IDPermiso, Nombre, Descripcion, Categoria, Precio, Fecha_Adquirido, Estatus, Detalles_Estatus) VALUES
(1, 'Servidor TI',       'Servidor para gestión interna',    'Hardware',      25000.00, '2023-06-15', 'Disponible',     ''),
(5, 'Software ERP',      'ERP de contabilidad',              'Software',      12000.00, '2024-01-10', 'En Reparación', 'Actualización pendiente'),
(3, 'Sala Ambiental',    'Auditorio para reuniones',         'Instalaciones',  8000.00, '2022-11-05', 'Disponible',     '');

-- =========================================
-- 6. Insertar Servicios
-- =========================================
INSERT INTO Servicios (IDProceso, IDPermiso, Nombre, Descripcion, TipoUsuario) VALUES
(1, 2, 'Soporte TI',       'Atención de incidencias de TI',        'Colaborador'),
(2, 3, 'Permiso Ambiental','Gestión de permisos ambientales',      'AgendaAmbiental'),
(3, 4, 'Aprobación Ejecutiva','Validación de decisiones estratégicas','AltaDireccion');

-- =========================================
-- 7. Insertar Administradores
-- =========================================
INSERT INTO Administrador (IDUsuario) VALUES
(1),  -- Ana como admin
(4);  -- Carlos como admin

-- =========================================
-- 8. Asignar Administradores a Procesos
-- =========================================
INSERT INTO Administrador_Proceso (IDAdministrador, IDProceso) VALUES
(1, 1),  -- Ana gestiona Apertura de ticket
(2, 3);  -- Carlos gestiona Decisión ejecutiva

-- =========================================
-- 9. Asignar Administradores a Servicios
-- =========================================
INSERT INTO Administrador_Servicio (IDAdministrador, IDServicio) VALUES
(1, 1),  -- Ana en Soporte TI
(2, 3);  -- Carlos en Aprobación Ejecutiva

-- =========================================
-- 10. Asignar Administradores a Infraestructura
-- =========================================
INSERT INTO Administrador_Infraestructura (IDAdministrador, IDInfraestructura) VALUES
(1, 1),  -- Ana responsable del Servidor TI
(2, 2);  -- Carlos responsable del Software ERP

-- =========================================
-- 11. Relacionar Servicios e Infraestructura
-- =========================================
INSERT INTO Servicio_Infraestructura (IDServicio, IDInfraestructura) VALUES
(1, 1),  -- Soporte TI usa Servidor TI
(2, 3);  -- Permiso Ambiental usa Sala Ambiental

-- =========================================
-- 12. Insertar Tickets
-- =========================================
INSERT INTO Tickets (IDUsuario, IDAdministrador, IDProceso, IDServicio, IDInfraestructura, Asunto, Detalle_Solicitud, Fecha_Creacion, Estatus_User, Estatus_Admin) VALUES
(2, 1, 1, 1, 1, 'Imposible acceder al ERP', 'El sistema ERP muestra error 500 al iniciar sesión.', '2025-07-01 09:15:00', 'Pendiente', 'Pendiente'),
(3, 1, 2, 2, 3, 'Solicitud de permiso',     'Necesito tramitar permiso ambiental para evento.', '2025-07-02 14:30:00', 'En Proceso', 'En Proceso'),
(5, 2, 3, 3, NULL, 'Decisión presupuesto',    'Solicito aprobación de presupuesto Q3.',      '2025-07-03 11:00:00', 'Pendiente', 'Pendiente');

-- =========================================
-- 13. Insertar ChatTicket
-- =========================================
INSERT INTO ChatTicket (IDTicket, IDUsuario, Texto, Fecha) VALUES
(1, 2, 'El error persiste, aparece pantalla blanca.', '2025-07-01 10:00:00'),
(1, 1, 'Revisaré los logs y te aviso.',             '2025-07-01 10:30:00'),
(2, 3, '¿Cuál es la fecha límite para el permiso?', '2025-07-02 15:00:00');

-- =========================================
-- 14. Insertar Encuesta de Satisfacción
-- =========================================
INSERT INTO EncuestaSatisfaccion (IDTicket, Respuesta1, Respuesta2, Respuesta3, ComentariosAdicionales) VALUES
(1, 'Bien',  'Bien',  'Medio', 'Atención rápida y efectiva.'),
(2, 'Medio', 'Bien',  'Bien', 'Proceso ágil, gracias.');

-- =========================================
-- 15. Insertar Buzón de Sugerencias
-- =========================================
INSERT INTO BuzonSugerencias (Mensaje) VALUES
('Sería útil contar con notificaciones automáticas por correo.'),
('Agregar un módulo de reportes en PDF para tickets cerrados.');