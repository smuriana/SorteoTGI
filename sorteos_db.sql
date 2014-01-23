-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-01-2014 a las 01:08:32
-- Versión del servidor: 5.5.32
-- Versión de PHP: 5.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `sorteos_db`
--
CREATE DATABASE IF NOT EXISTS `sorteos_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `sorteos_db`;

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `procedimientoPrueba`(IN `id` INT, IN `winnerNumber` INT)
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE varIdUser,varNumber INT;
  DECLARE tituloSorteo VARCHAR(200);
  DECLARE cursorParticipantes CURSOR FOR SELECT id_user, number FROM ballot WHERE id_ruffle=id;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
  
  SET tituloSorteo = (SELECT title FROM ruffle WHERE ruffle.id=id);
  OPEN cursorParticipantes;

  REPEAT
    FETCH cursorParticipantes INTO varIdUser, varNumber;

    IF NOT done THEN
       IF (varNumber = winnerNumber) THEN
       	INSERT INTO notification (id_user, url, text, visible, title, image) VALUES (varIdUser,CONCAT('/descripcion/',id,'/',tituloSorteo), 'Enhorabuena! le ha tocado un perrito piloto', 1, 'Sorteo terminado', '');          
       ELSE
        INSERT INTO notification (id_user, url, text, visible, title, image) VALUES (varIdUser,CONCAT('/descripcion/',id,'/',tituloSorteo), 'Lo siento, pero ha perdido, eres un Gañan!', 1, 'Sorteo terminado', '');
       END IF;
    END IF;
  UNTIL done END REPEAT;

  CLOSE cursorParticipantes;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test2`()
begin

select ‘Hello World’;

end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ballot`
--

CREATE TABLE IF NOT EXISTS `ballot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_ruffle` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=22 ;

--
-- Volcado de datos para la tabla `ballot`
--

INSERT INTO `ballot` (`id`, `id_user`, `id_ruffle`, `number`, `status`) VALUES
(1, 28, 1, 3, 0),
(2, 28, 2, 63, 2),
(3, 28, 3, 44, 0),
(4, 28, 3, 14, 0),
(5, 28, 3, 40, 0),
(6, 28, 2, 42, 2),
(7, 28, 3, 34, 0),
(8, 28, 2, 33, 2),
(9, 28, 3, 15, 0),
(10, 28, 2, 22, 2),
(11, 28, 2, 4, 2),
(12, 28, 2, 37, 2),
(13, 28, 2, 0, 2),
(14, 28, 2, 34, 2),
(15, 28, 2, 12, 2),
(16, 28, 2, 31, 2),
(17, 28, 2, 2, 2),
(18, 28, 2, 5, 2),
(19, 28, 1, 83, 0),
(20, 28, 2, 71, 2),
(21, 28, 8, 95, 0);

--
-- Disparadores `ballot`
--
DROP TRIGGER IF EXISTS `compraTickets`;
DELIMITER //
CREATE TRIGGER `compraTickets` AFTER INSERT ON `ballot`
 FOR EACH ROW UPDATE ruffle SET sold_ballots=sold_ballots+1 WHERE id=NEW.id_ruffle
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `conversation`
--

CREATE TABLE IF NOT EXISTS `conversation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_user_to` int(11) NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `id_user` (`id_user`,`id_user_to`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=9 ;

--
-- Volcado de datos para la tabla `conversation`
--

INSERT INTO `conversation` (`id`, `id_user`, `id_user_to`, `date`) VALUES
(7, 32, 28, '2014-01-22 21:05:54'),
(8, 42, 28, '2014-01-22 21:27:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notification`
--

CREATE TABLE IF NOT EXISTS `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `text` varchar(200) NOT NULL,
  `visible` tinyint(1) NOT NULL DEFAULT '1',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(200) NOT NULL,
  `id_user_to` int(11) NOT NULL,
  `id_conversation` int(11) NOT NULL,
  `dialog` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=55 ;

--
-- Volcado de datos para la tabla `notification`
--

INSERT INTO `notification` (`id`, `id_user`, `text`, `visible`, `time`, `title`, `id_user_to`, `id_conversation`, `dialog`) VALUES
(53, 32, 'Hola, estoy interesado en tu nexus 4, me gustaría obtener mas información antes de decidirme por comprar un número elevado de papeletas ;)', 0, '2014-01-22 21:05:54', '', 28, 7, 1),
(54, 42, 'Ola k ase?', 0, '2014-01-22 21:27:52', '', 28, 8, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opinion`
--

CREATE TABLE IF NOT EXISTS `opinion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `id_ruffle` int(11) NOT NULL,
  `rapidez` int(11) NOT NULL,
  `trato` int(11) NOT NULL,
  `estado_producto` int(11) NOT NULL,
  `calidad_precio` int(11) NOT NULL,
  `general` int(11) NOT NULL,
  `id_user_opina` int(11) NOT NULL,
  `comentario` varchar(200) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Volcado de datos para la tabla `opinion`
--

INSERT INTO `opinion` (`id`, `id_user`, `id_ruffle`, `rapidez`, `trato`, `estado_producto`, `calidad_precio`, `general`, `id_user_opina`, `comentario`) VALUES
(1, 29, 4, 3, 2, 1, 1, 2, 28, 'Este tío es un impresentable, el muy bajo me ha tangao'),
(2, 29, 4, 2, 2, 2, 2, 1, 28, 'dame mi audiiiiiiiiiiiiiiii');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ruffle`
--

CREATE TABLE IF NOT EXISTS `ruffle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `description` varchar(10000) NOT NULL,
  `short_description` varchar(160) NOT NULL,
  `status` float NOT NULL,
  `bill` tinyint(1) NOT NULL,
  `guarantee` tinyint(1) NOT NULL,
  `init_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `final_date` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ballots` int(11) NOT NULL,
  `price` float NOT NULL,
  `picture1` varchar(250) NOT NULL DEFAULT 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg',
  `picture2` varchar(250) NOT NULL DEFAULT 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg',
  `picture3` varchar(250) NOT NULL DEFAULT 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg',
  `tags` varchar(250) NOT NULL,
  `sold_ballots` int(11) DEFAULT '0',
  `title` varchar(50) NOT NULL,
  `winnerNumber` int(11) DEFAULT NULL,
  `visible` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=28 ;

--
-- Volcado de datos para la tabla `ruffle`
--

INSERT INTO `ruffle` (`id`, `create_date`, `user_id`, `description`, `short_description`, `status`, `bill`, `guarantee`, `init_date`, `final_date`, `ballots`, `price`, `picture1`, `picture2`, `picture3`, `tags`, `sold_ballots`, `title`, `winnerNumber`, `visible`) VALUES
(1, '2013-11-20 19:30:21', 28, 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.\n\nLo vendo por haber adquirido el nuevo nexus 5', 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.', 9, 0, 0, '2013-11-20 23:00:00', '2014-01-19 23:00:00', 100, 300, '/img/nexus1.jpg', '/img/nexus2.jpg', '/img/nexus1.jpg', 'nexus 4, móvil, smartphone', 44, 'Sorteo Nexus 4', 31958, 1),
(2, '2013-12-21 01:30:40', 29, 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km, 6900 eur., El coche esta en perfecto estado , mejor verlo y probarlo , tiene todo al día , libro de revisiones sellado en la casa audi . con todas las facturas , correas de distribución , filtros , pastillas ect...\r\nLo vendo por aumento de familia , acepto prueba mecánica , el coche esta como nuevo a tenido un mantenimiento excelente y siempre se le a echado diésel ultimate .\r\nTodos lo extras ESP,ordenador de abordo , doble clima ect...', 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km. El coche esta en perfecto estado', 1, 1, 0, '2013-12-20 23:00:00', '2014-01-27 23:00:00', 100, 6900, '/img/audi1.jpg', '/img/audi2.jpg', '', '', 16, 'Audi A4', 0, 4),
(3, '2013-12-21 01:36:15', 28, 'El nuevo IPHONE 5S, es el modelo de 16 GB precintado y en color BLANCO Y PLATA. Lo tengo en mi poder y se envia al dia siguiente del sorteo directamente al ganador. ', 'Precintado + 16 GB + Libre + Plateado y Blanquito!', 1, 1, 1, '2013-12-20 23:00:00', '2013-12-30 23:00:00', 100, 700, '/img/iphone1.jpg', '/img/iphone2.jpg', '', '', 8, 'Iphone 5S de 16GB Libre', NULL, 3),
(4, '2013-12-21 01:30:40', 29, 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km, 6900 eur., El coche esta en perfecto estado , mejor verlo y probarlo , tiene todo al día , libro de revisiones sellado en la casa audi . con todas las facturas , correas de distribución , filtros , pastillas ect...\r\nLo vendo por aumento de familia , acepto prueba mecánica , el coche esta como nuevo a tenido un mantenimiento excelente y siempre se le a echado diésel ultimate .\r\nTodos lo extras ESP,ordenador de abordo , doble clima ect...', 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km. El coche esta en perfecto estado', 1, 1, 0, '2013-12-20 23:00:00', '2013-12-27 23:00:00', 100, 6900, '/img/audi1.jpg', '/img/audi2.jpg', '', '', 3, 'Audi A4', NULL, 3),
(6, '2014-01-20 22:25:17', 2, 'descripction', 'short_description', 2, 1, 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 1, 2, 'picture1', 'picture2', 'picture3', 'tags', 2, 'title', 2, 2),
(7, '2014-01-20 22:52:56', 28, 'Esto va a explotar, ya verah', 'Este es el primer sorteo de prueba', 0, 1, 0, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 100, 1000, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'Sorteo prueba', NULL, 0),
(8, '2014-01-21 15:52:55', 42, 'Hola vendo un renault 5 con el motor nuevo.   Entrego tambien con una caja de cambios de recanbio,  una bomba de agua,  un carter,  bomda de gasolina.   Tiene itv asta febrero.   Precio negosible. ', 'Hola vendo un renault 5 con el motor nuevo.   Entrego tambien con una caja de cambios de recanbio,  una bomba de agua,  un carter,  bomda de gasolina.  ', 0, 0, 0, '2014-01-21 03:01:55', '2014-02-21 03:02:55', 100, 600, 'http://91.229.239.12/fg/1167/15/renault-de-segunda-mano/Renault-r5-116715271_1.jpg', 'http://91.229.239.12/fg/1167/15/renault-de-segunda-mano/Renault-r5-116715271_2.jpg', 'http://91.229.239.12/fg/1167/15/renault-de-segunda-mano/Renault-r5-116715271_3.jpg', '', 1, 'RENAULT - R5', NULL, 0),
(9, '2014-01-21 15:52:56', 40, 'Se alquila bmw 530 color azul marino para bodas ú otros eventos con chofer, desplazamientos a toda españa, consultar tarifa. Contesto wassap. .. Color Azul marino', 'Se alquila bmw 530 color azul marino para bodas ú otros eventos con chofer, desplazamientos a toda españa, consultar tarifa. Contesto wassap. .. Color', 0, 0, 0, '2014-01-21 03:01:56', '2014-02-21 03:02:56', 100, 200, 'http://91.229.239.8/fg/1165/58/otros-recambios/BMW-530-116558110_1.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'BMW - 530', NULL, 0),
(10, '2014-01-21 15:52:57', 41, 'Playa.  Apartamento de 2 dormitorios en nerja,  baÑo,  salon-comedor,  cocina equipada,  amueblado,  terraza,  piscina,  garaje y a solo 100 metros de la playa. . 2ª Planta.', 'Playa.  Apartamento de 2 dormitorios en nerja,  baÑo,  salon-comedor,  cocina equipada,  amueblado,  terraza,  piscina,  garaje y a solo 100 metros de la', 0, 0, 0, '2014-01-21 03:01:57', '2014-02-21 03:02:57', 100, 450, 'http://91.229.239.12/fg/119/86/alquiler-de-apartamentos/Apartamento-en-Nerja-con-2-dormitorios-11986994_1.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'APARTAMENTO EN NERJA CON 2 DORMITORIOS', NULL, 0),
(11, '2014-01-21 15:52:58', 36, ' Vendo estupendo bajo mostrador refrigerado de acero inoxidable  de 2 puertas mide 2 mt de largo ,  interesados contactar por telefono. ', ' Vendo estupendo bajo mostrador refrigerado de acero inoxidable  de 2 puertas mide 2 mt de largo ,  interesados contactar por telefono.', 0, 0, 0, '2014-01-21 03:01:58', '2014-02-21 03:02:58', 100, 750, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'BAJO MOSTRADOR REFRIGERADO DE 2 PUERTAS', NULL, 0),
(12, '2014-01-21 15:52:59', 31, 'Despiece yamaha ractor 660, . . Mando despiece a toda España. . . . . . . . . . . . . . . . . . . . ', 'Despiece yamaha ractor 660, . . Mando despiece a toda España. . . . . . . . . . . . . . . . . . . .', 0, 0, 0, '2014-01-21 03:01:59', '2014-02-21 03:02:59', 100, 100, 'http://91.229.239.8/fg/807/40/quads/Yamaha-660-ractor-80740250_3.jpg', 'http://91.229.239.8/fg/807/40/quads/Yamaha-660-ractor-80740250_1.jpg', 'http://91.229.239.8/fg/807/40/quads/Yamaha-660-ractor-80740250_2.jpg', '', 0, 'YAMAHA - 660  RACTOR', NULL, 1),
(13, '2014-01-21 15:53:00', 37, 'Se vende despiece. Mando pieza a toda España. . . . . TENGO WASSAP', 'Se vende despiece. Mando pieza a toda España. . . . . TENGO', 0, 0, 0, '2014-01-21 03:01:00', '2014-02-21 03:02:00', 100, 100, 'http://91.229.239.8/fg/805/39/quads/Yamaha-660-ractor-80539311_4.jpg', 'http://91.229.239.8/fg/805/39/quads/Yamaha-660-ractor-80539311_5.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'YAMAHA - 660  RACTOR', NULL, 0),
(14, '2014-01-21 15:53:01', 38, ' 8130 vendo escaparAte de aluminio rojo mas cristal laminar de medidas 185, 205, 240 por 100cms, buen precio, consultenos,   nos encontramos en granada a-92,  salida 211,  junto hotel restaurante el cruce,  visite nuestra tienda con más de 1000m/2 de exposición,  o nuestra tienda online,  puede verla visitando este enlace en youtube http:  //www.  youtube.  com/watch?v=fyz7jm3bedm .  realizamos envios a toda españa.  24-48h.  responsable almacén fran gómez', ' 8130 vendo escaparAte de aluminio rojo mas cristal laminar de medidas 185, 205, 240 por 100cms, buen precio, consultenos,   nos encontramos en granada', 0, 0, 0, '2014-01-21 03:01:01', '2014-02-21 03:02:01', 100, 100, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'ESCAPARATE ALUMINIO ROJO +CRISTAL LAMINA', NULL, 0),
(15, '2014-01-21 15:53:02', 39, ' Se vende carrito/coche para bebe de 3 piezas,  maxicosi, capazo y silleta.  Se desmonta muy fácilmente.  El capazo y el maxicosi están prácticamente nuevos. ', ' Se vende carrito/coche para bebe de 3 piezas,  maxicosi, capazo y silleta.  Se desmonta muy fácilmente.  El capazo y el maxicosi están prácticamente', 0, 0, 0, '2014-01-21 03:01:02', '2014-02-21 03:02:02', 100, 145, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'CARRITO PARA BEBE BE COOL PRO', NULL, 0),
(16, '2014-01-21 15:53:04', 31, ' Tengo mini pincher muy bonito en color negro fuego intersados atiendo por wasap la monta vale 150?', ' Tengo mini pincher muy bonito en color negro fuego intersados atiendo por wasap la monta vale', 0, 0, 0, '2014-01-21 03:01:04', '2014-02-21 03:02:04', 100, 150, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'PINCHER PARA MONTA', NULL, 0),
(17, '2014-01-21 15:53:05', 29, 'Buenas, vendo o cambio x movil note2 o iphone, dando diferencia si hiciera falta, esta pitbike de 125 4tiempo, 4 marcha, va perfecto, lo unico que la pipeta de la bujia esta quitada, x lo demas esta perfectisima, cambiaria x table tambien', 'Buenas, vendo o cambio x movil note2 o iphone, dando diferencia si hiciera falta, esta pitbike de 125 4tiempo, 4 marcha, va perfecto, lo unico que la pipeta', 0, 0, 0, '2014-01-21 03:01:05', '2014-02-21 03:02:05', 100, 240, 'http://91.229.239.8/fg/1109/69/motos-de-cross/Honda-pitbike-110969947_1.jpg', 'http://91.229.239.8/fg/1109/69/motos-de-cross/Honda-pitbike-110969947_2.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'HONDA - PITBIKE', NULL, 0),
(18, '2014-01-21 15:53:07', 35, ' vendo 2 mesitas de noche de madera maciza pintadas en crema envejecido con 4 cajones,  miden 58 de ancho,  73 de alto y 44 de fondo tambien tengo cabecero si interesa,  precio fabrica', ' vendo 2 mesitas de noche de madera maciza pintadas en crema envejecido con 4 cajones,  miden 58 de ancho,  73 de alto y 44 de fondo tambien tengo cabecero', 0, 0, 0, '2014-01-21 03:01:07', '2014-02-21 03:02:07', 100, 160, 'http://91.229.239.8/fg/1006/03/mesillas/mesitas-de-noche-100603525_1.jpg', 'http://91.229.239.8/fg/1006/03/mesillas/mesitas-de-noche-100603525_2.jpg', 'http://91.229.239.8/fg/1006/03/mesillas/mesitas-de-noche-100603525_3.jpg', '', 0, 'MESITAS DE NOCHE', NULL, 0),
(19, '2014-01-21 15:53:07', 35, ' se vende despiece de yamaha majestic 400 esta en perfecto estado de motor esta en muy buenas condiciones llamenos para pedirnos sus piezas y le atenderemos en los tlfns de contacto  visitenos en www. desguacedemotosyquads. com', ' se vende despiece de yamaha majestic 400 esta en perfecto estado de motor esta en muy buenas condiciones llamenos para pedirnos sus piezas y le atenderemos', 0, 0, 0, '2014-01-21 03:01:07', '2014-02-21 03:02:07', 100, 100, 'http://91.229.239.8/fg/997/21/recambios-y-despieces-de-motos/yamaha-majestic-400-yp400-99721368_1.jpg', 'http://91.229.239.8/fg/997/21/recambios-y-despieces-de-motos/yamaha-majestic-400-yp400-99721368_2.jpg', 'http://91.229.239.8/fg/997/21/recambios-y-despieces-de-motos/yamaha-majestic-400-yp400-99721368_3.jpg', '', 0, 'YAMAHA MAJESTIC 400  YP400', NULL, 0),
(20, '2014-01-21 15:53:09', 37, 'Ref.  La Romanilla.  Vivienda de 2 dormitorios bien situada,  zona:  La Romanilla,  a pocos metros del Puerto de Roquetas.  Se trata de una calle muy tranquila.  Vivienda seminueva. . Playa a unos 200 metros. 2ª Planta. CE: G', 'Ref.  La Romanilla.  Vivienda de 2 dormitorios bien situada,  zona:  La Romanilla,  a pocos metros del Puerto de Roquetas.  Se trata de una calle muy', 0, 0, 0, '2014-01-21 03:01:09', '2014-02-21 03:02:09', 100, 320, 'http://91.229.239.8/fg/1055/89/alquiler-de-pisos/La-Romanilla-320?-La-Romanilla-105589058_1.jpg', 'http://91.229.239.8/fg/1055/89/alquiler-de-pisos/La-Romanilla-320?-La-Romanilla-105589058_2.jpg', 'http://91.229.239.8/fg/1055/89/alquiler-de-pisos/La-Romanilla-320?-La-Romanilla-105589058_3.jpg', '', 0, 'LA ROMANILLA 320? - LA ROMANILLA', NULL, 0),
(21, '2014-01-21 15:53:10', 28, ' Vendo billar en buen estado precio casi regalado.  ¡urge vender! (atiendo wasap y llamadas,  no correos). ', ' Vendo billar en buen estado precio casi regalado.  ¡urge vender! (atiendo wasap y llamadas,  no correos).', 0, 0, 0, '2014-01-21 03:01:10', '2014-02-21 03:02:10', 100, 250, 'http://91.229.239.8/fg/1136/46/billares/¡¡billar-barato!!-113646846_1.jpg', 'http://91.229.239.8/fg/1136/46/billares/¡¡billar-barato!!-113646846_2.jpg', 'http://91.229.239.8/fg/1136/46/billares/¡¡billar-barato!!-113646846_3.jpg', '', 0, '¡¡BILLAR BARATO!!', NULL, 0),
(22, '2014-01-21 15:53:11', 29, ' vendo 2 mesitas de noche de madera maciza pintadas en crema envejecido con 4 cajones,  miden 58 de ancho,  73 de alto y 44 de fondo tambien tengo cabecero si interesa,  precio fabrica', ' vendo 2 mesitas de noche de madera maciza pintadas en crema envejecido con 4 cajones,  miden 58 de ancho,  73 de alto y 44 de fondo tambien tengo cabecero', 0, 0, 0, '2014-01-21 03:01:11', '2014-02-21 03:02:11', 100, 160, 'http://91.229.239.8/fg/1006/03/otros-muebles/mesitas-de-noche-100603733_1.jpg', 'http://91.229.239.8/fg/1006/03/otros-muebles/mesitas-de-noche-100603733_2.jpg', 'http://91.229.239.8/fg/1006/03/otros-muebles/mesitas-de-noche-100603733_3.jpg', '', 0, 'MESITAS DE NOCHE', NULL, 0),
(23, '2014-01-21 15:53:12', 36, 'Avd los remedios.  Se alquila local comercial de 80m2 ,  muy amplio ,  totalmente nuevo ,  con 2 baños .     Situado en muy buena zona ,  con buenas vistas y aparcamiento.     NO SE ALQUILA PARA BARES NI RESTAURANTES.     Para cualquier otra duda contacte conmigo.   Gracias. ', 'Avd los remedios.  Se alquila local comercial de 80m2 ,  muy amplio ,  totalmente nuevo ,  con 2 baños .     Situado en muy buena zona ,  con buenas vistas', 0, 0, 0, '2014-01-21 03:01:12', '2014-02-21 03:02:12', 100, 400, 'http://91.229.239.12/fg/979/20/alquiler-de-locales-comerciales/Local-comercial-en-vejer-de-la-frontera-97920087_1.jpg', 'http://91.229.239.12/fg/979/20/alquiler-de-locales-comerciales/Local-comercial-en-vejer-de-la-frontera-97920087_2.jpg', 'http://91.229.239.12/fg/979/20/alquiler-de-locales-comerciales/Local-comercial-en-vejer-de-la-frontera-97920087_3.jpg', '', 0, 'LOCAL COMERCIAL EN VEJER DE LA FRONTERA', NULL, 0),
(24, '2014-01-21 15:53:14', 29, 'Vendo suzuki rmx muy bien cuidada,  las fotos del anuncio son actuales,  muy muy buen estado y poquisimo uso,  vendo por necesidad ya que tambien tengo coche y para que estee guardada cojiendo polvo que la disfrute otro,  esta de fabrica,  debe pasar itv sin problemas,  ven a verla,  tan solo como suena seguro te la quedas.  Tiene exactamente 24. 444km todo funciona perfectamente ya que la he cuidado mucho y a dormido bajo techo siempre.  650? NEGOCIABLES.  Escucho ofertas razonables,  esta muy muy nueva. ', 'Vendo suzuki rmx muy bien cuidada,  las fotos del anuncio son actuales,  muy muy buen estado y poquisimo uso,  vendo por necesidad ya que tambien tengo', 0, 0, 0, '2014-01-21 03:01:14', '2014-02-21 03:02:14', 100, 650, 'http://91.229.239.12/fg/328/71/ciclomotores-de-segunda-mano/Suzuki-Rmx-negociable-32871192_1.jpg', 'http://91.229.239.12/fg/328/71/ciclomotores-de-segunda-mano/Suzuki-Rmx-negociable-32871192_2.jpg', 'http://91.229.239.12/fg/328/71/ciclomotores-de-segunda-mano/Suzuki-Rmx-negociable-32871192_3.jpg', '', 0, 'SUZUKI - RMX NEGOCIABLE', NULL, 0),
(25, '2014-01-21 15:53:14', 30, ' Caja cambios A 6382601800 Mercedes Vito 108 110 112 2, 2cdi 90KW 122PS 1998-2003', ' Caja cambios A 6382601800 Mercedes Vito 108 110 112 2, 2cdi 90KW 122PS', 0, 0, 0, '2014-01-21 03:01:14', '2014-02-21 03:02:14', 100, 300, 'http://91.229.239.8/fg/512/67/otros-recambios/caja-cambios-mercedes-benz-vito-51267258_1.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'CAJA CAMBIOS MERCEDES BENZ VITO', NULL, 0),
(26, '2014-01-21 15:53:16', 31, ' Conjunto mesa de 120 X 75 mas 4 sillas nuevas a estrenar en color cerezo o wengué por 227 €.  OFERTA VALIDA HASTA FIN DE EXISTENCIAS.  ref:  091 whatsapp', ' Conjunto mesa de 120 X 75 mas 4 sillas nuevas a estrenar en color cerezo o wengué por 227 €.  OFERTA VALIDA HASTA FIN DE EXISTENCIAS.  ref:  091', 0, 0, 0, '2014-01-21 03:01:16', '2014-02-21 03:02:16', 100, 227, 'http://91.229.239.8/fg/815/98/mesas/Mesa-+-4-sillas-81598344_1.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'MESA + 4 SILLAS', NULL, 0),
(27, '2014-01-21 15:53:17', 38, ' Vendo Un Cigueñal Nuevo de Calidad Garantizada,  Reforzado para Yamaha Majesty 250,  Yamaha X City 250,  Yamaha X Max 250 y Yamaha Versity 300.  Fabricacion Italiana.   Dispongo de Whatsapp.  Lo puedo enviar a cualquier lugar de España. ', ' Vendo Un Cigueñal Nuevo de Calidad Garantizada,  Reforzado para Yamaha Majesty 250,  Yamaha X City 250,  Yamaha X Max 250 y Yamaha Versity 300. ', 0, 0, 0, '2014-01-21 03:01:17', '2014-02-21 03:02:17', 100, 240, 'http://91.229.239.8/fg/242/67/recambios-y-despieces-de-motos/Cigueñal-Yamaha-Majesty/X-City/X-Max-24267411_1.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'CIGUEñAL YAMAHA MAJESTY X CITY X MAX', NULL, 0);

--
-- Disparadores `ruffle`
--
DROP TRIGGER IF EXISTS `NumeroPremiadoSorteo`;
DELIMITER //
CREATE TRIGGER `NumeroPremiadoSorteo` AFTER UPDATE ON `ruffle`
 FOR EACH ROW IF NOT (NEW.winnerNumber <=> OLD.winnerNumber) THEN
CALL procedimientoPrueba(OLD.id, NEW.winnerNumber);
END IF
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `roles` varchar(255) NOT NULL,
  `nick` varchar(50) NOT NULL,
  `rango` int(11) DEFAULT '0',
  `sexo` tinyint(1) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `cp` varchar(5) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `localidad` varchar(100) NOT NULL,
  `registerDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `picture` varchar(300) NOT NULL DEFAULT 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nick` (`nick`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=43 ;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `roles`, `nick`, `rango`, `sexo`, `nombre`, `apellidos`, `direccion`, `cp`, `provincia`, `localidad`, `registerDate`, `picture`) VALUES
(28, 'admin@admin.com', 'nhDr7OyKlXQju+Ge/WKGrPQ9lPBSUFfpK+B1xqx/+8zLZqRNX0+5G1zBQklXUFy86lCpkAofsExlXiorUcKSNQ==', 'ROLE_USER,ROLE_ADMIN', 'admin', 4, 1, 'Manuel', 'Pancorbo Pestaña', 'Molino, 13', '23640', 'Jaén', 'Torre del Campo', '2014-01-18 18:03:52', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(29, 'sergio@gmail.com', 'DVW9Uk/9AUnG7zqtOXMnofH860FKgwzoIv1A/n3VmpaLD3RMgHydHj3sPy+aGQ7pMIJz0wY6hdiGHNVhUDh4xQ==', 'ROLE_USER', 'muriana', 5, 0, NULL, NULL, NULL, NULL, '', '', '2014-01-18 18:03:52', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(30, 'sergio@sergio.com', 'lRrOl/vg7pWwIyo8Rc+dJ3k6ui9kDPccWMwE4QoxoJ69ProA9zQ9gaz6oaHON4B6uLCk0zhMSj/kmXMfHOLkaw==', 'ROLE_USER', 'sergio', 5, NULL, NULL, NULL, NULL, NULL, NULL, '', '2014-01-19 10:25:47', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(31, 'manuel@manuel.com', 'TPOXMBpuI2aahUNWCOBI9J+NlhNFtCGI+yoADy9bNK41hLU4BUbGP1cloq/dZqo/Wj9d9VdNsrPiHkazAv/3xQ==', 'ROLE_USER', 'manuel', 2, NULL, NULL, NULL, NULL, NULL, NULL, '', '2014-01-19 10:27:05', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(32, 'mpancorbo@dapda.com', 'YQmCzBJpekXbNcBtprEvbpTbw1JhOX7AiNFduSp6G6dNxDsVc8rNNIDnnswCPGyWE4vHOdrhlQke+ROLzVWDxQ==', 'ROLE_USER', 'mpancorbo', 1, NULL, NULL, NULL, NULL, NULL, NULL, '', '2014-01-19 23:58:18', ''),
(33, 'usu33@usu33.com', 'wy71cltmPWs6cwFrNEyvhjF+HIHt7cE68OnwASAQLkOLu8oSgTT65Kep89XWT4jZ3XIDzDp24KfP8bfYY+aDkg==', 'ROLE_USER', '?Delitth', 3, 1, 'Galeno', 'Padrón', 'C/ Cuevas de Ambrosio 2', '23690', 'Jaén', 'Frailes', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(34, 'usu34@usu34.com', 'RLQXipB6J68GNw9u+S7HcioyHlWC7yVkseWnJ0KC6EQXWzDXlkIVW3cLetTfevdQ3PlSq+WKOZwjZhNVeCvv0A==', 'ROLE_USER', 'Wittleen', 0, 1, 'Crescencio', 'Irizarry', 'Avda. Rio Nalon 4', '33430', 'Asturias', 'Carreño', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(35, 'usu35@usu35.com', 'kjTIYXd5+dVuc0eCK80jxZTpHtwVJcqMbLilxOyrIKqkFaLXkd2mcPemTME5zAJ1KpF2cseWZGSAu1x6wpIFcA==', 'ROLE_USER', 'Whour1982', 3, 1, 'Abaco', 'Samaniego', 'Pl. Virgen Blanca 42', '08759', 'Barcelona', 'Vallirana', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(36, 'usu36@usu36.com', 'n2WPyul5DPsb+KXLdLtJuzjHwMtHk/74bFo9QgkJe25gfwUcFLrePTxApvDUrvMDq+BWzJJj5maz9L4vLvgMQA==', 'ROLE_USER', 'Thermed47', 3, 1, 'Johann', 'Zamora', 'Alcon Molina 24', '31191', 'Navarre', 'Beriáin', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(37, 'usu37@usu37.com', 'cnE6w7nihXNDczShuKAciRf4i6cnzAULEt3mMcgCPBkEvqW1vQogt5GFYWLi1YdFglfvGy4F1rmLqQZpkCfgqQ==', 'ROLE_USER', 'Bobitives1950', 2, 0, 'Lesmes', 'Matos', 'Carretera Cádiz-Málaga 48', '20570', 'Guipúzcoa', 'Bergara', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(38, 'usu38@usu38.com', 'FWwcJdEr1VbMeLL93vasCvVEjHrlo+yfRoEf8HnvTnwnWN8O8HyX8Wa8mJQVd40ZmWQ6D3pTrhaIibd9OaVC+w==', 'ROLE_USER', 'Theromstaks1969', 0, 0, 'Heraclea', 'Cruz', 'Castelao 41', '48891', 'Biscay', 'Lanestosa', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(39, 'usu39@usu39.com', '1fGG+nMCWQwZD75lRaT5HOz+bqS65k19RGwwcDaSd6u0xPL/f7ACywBUFofvTF5+cRZkczJCW5XI5fDfTTEh1g==', 'ROLE_USER', 'Saidectered', 3, 0, 'Sintiques', 'Madera', 'Av. Zumalakarregi 22', '03111', 'Alicante', 'Busot', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(40, 'usu40@usu40.com', 'jFTk2oa/4z4lIfewNXD5HILJ59V4Chkr9UNMPBlWiaw4ckOkiewl/XZOXy9zIECVjCsHyeqpiq8KsUwOf+s9LQ==', 'ROLE_USER', 'Namonsiver', 4, 1, 'Ettiene', 'Chacón', 'Cádiz 14', '18516', 'Granada', 'Lugros', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(41, 'usu41@usu41.com', 'mh7fdQLSjdKXYSfP3VfQi4j+HL6Q1KCrKk1tdPPj+3ghdr2vIlPPPDNsNLpXRp+wDp4oG4+cPeaB/VIwYCJ6KA==', 'ROLE_USER', 'Walonly', 3, 0, 'Janette', 'Guillén', 'Urzáiz 93', '44540', 'Teruel', 'Albalate del Arzobispo', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(42, 'usu42@usu42.com', 'NtqotRBmkl3nG7+OlLmr6kZH9RegOvJ4ZbjuKqLNkcepU7sWpeIp6R6SQw+Yek2CHKbhtC4SrovdagoM+kO3/Q==', 'ROLE_USER', 'Nuals1931', 3, 1, 'Raidis', 'Nino', 'Alcon Molina 91', '31010', 'Navarre', 'Barañain', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
