-- phpMyAdmin SQL Dump
-- version 4.0.10
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 18-01-2014 a las 12:50:18
-- Versión del servidor: 5.6.14
-- Versión de PHP: 5.5.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `sorteos_db`
--

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
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Volcado de datos para la tabla `ballot`
--

INSERT INTO `ballot` (`id`, `id_user`, `id_ruffle`, `number`) VALUES
(1, 28, 1, 3),
(2, 28, 2, 63),
(3, 28, 3, 44),
(4, 28, 3, 14),
(5, 28, 3, 40),
(6, 28, 2, 42),
(7, 28, 3, 34),
(8, 28, 2, 33),
(9, 28, 3, 15),
(10, 28, 2, 22),
(11, 28, 2, 4),
(12, 28, 2, 37),
(13, 28, 2, 0),
(14, 28, 2, 34),
(15, 28, 2, 12),
(16, 28, 2, 31),
(17, 28, 2, 2),
(18, 28, 2, 5);

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
-- Estructura de tabla para la tabla `notification`
--

CREATE TABLE IF NOT EXISTS `notification` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_user` int(11) NOT NULL,
  `url` varchar(200) NOT NULL,
  `text` varchar(200) NOT NULL,
  `visible` tinyint(1) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `title` varchar(200) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=40 ;

--
-- Volcado de datos para la tabla `notification`
--

INSERT INTO `notification` (`id`, `id_user`, `url`, `text`, `visible`, `time`, `title`, `image`) VALUES
(28, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(29, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(30, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(31, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(32, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(33, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(34, 28, '/descripcion/2/Audi A4', 'Enhorabuena! le ha tocado un perrito piloto', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(35, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(36, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(37, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(38, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', ''),
(39, 28, '/descripcion/2/Audi A4', 'Lo siento, pero ha perdido, eres un Gañan!', 0, '2014-01-18 11:27:54', 'Sorteo terminado', '');

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
  `picture1` varchar(250) NOT NULL,
  `picture2` varchar(250) NOT NULL,
  `picture3` varchar(250) NOT NULL,
  `tags` varchar(250) NOT NULL,
  `sold_ballots` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `winnerNumber` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Volcado de datos para la tabla `ruffle`
--

INSERT INTO `ruffle` (`id`, `create_date`, `user_id`, `description`, `short_description`, `status`, `bill`, `guarantee`, `init_date`, `final_date`, `ballots`, `price`, `picture1`, `picture2`, `picture3`, `tags`, `sold_ballots`, `title`, `winnerNumber`) VALUES
(1, '2013-11-20 19:30:21', 28, 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.\n\nLo vendo por haber adquirido el nuevo nexus 5', 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.', 9, 0, 0, '2013-11-20 23:00:00', '2014-01-16 23:00:00', 100, 300, '/img/nexus1.jpg', '/img/nexus2.jpg', '/img/nexus1.jpg', 'nexus 4, móvil, smartphone', 43, 'Sorteo Nexus 4', 319589),
(2, '2013-12-21 01:30:40', 29, 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km, 6900 eur., El coche esta en perfecto estado , mejor verlo y probarlo , tiene todo al día , libro de revisiones sellado en la casa audi . con todas las facturas , correas de distribución , filtros , pastillas ect...\r\nLo vendo por aumento de familia , acepto prueba mecánica , el coche esta como nuevo a tenido un mantenimiento excelente y siempre se le a echado diésel ultimate .\r\nTodos lo extras ESP,ordenador de abordo , doble clima ect...', 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km. El coche esta en perfecto estado', 1, 1, 0, '2013-12-20 23:00:00', '2014-01-27 23:00:00', 100, 6900, '/img/audi1.jpg', '/img/audi2.jpg', '', '', 15, 'Audi A4', 0),
(3, '2013-12-21 01:36:15', 28, 'El nuevo IPHONE 5S, es el modelo de 16 GB precintado y en color BLANCO Y PLATA. Lo tengo en mi poder y se envia al dia siguiente del sorteo directamente al ganador. ', 'Precintado + 16 GB + Libre + Plateado y Blanquito!', 1, 1, 1, '2013-12-20 23:00:00', '2013-12-30 23:00:00', 100, 700, '/img/iphone1.jpg', '/img/iphone2.jpg', '', '', 8, 'Iphone 5S de 16GB Libre', NULL),
(4, '2013-12-21 01:30:40', 29, 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km, 6900 eur., El coche esta en perfecto estado , mejor verlo y probarlo , tiene todo al día , libro de revisiones sellado en la casa audi . con todas las facturas , correas de distribución , filtros , pastillas ect...\r\nLo vendo por aumento de familia , acepto prueba mecánica , el coche esta como nuevo a tenido un mantenimiento excelente y siempre se le a echado diésel ultimate .\r\nTodos lo extras ESP,ordenador de abordo , doble clima ect...', 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km. El coche esta en perfecto estado', 1, 1, 0, '2013-12-20 23:00:00', '2013-12-27 23:00:00', 100, 6900, '/img/audi1.jpg', '/img/audi2.jpg', '', '', 3, 'Audi A4', NULL);

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
  `rango` int(11) DEFAULT NULL,
  `sexo` tinyint(1) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellidos` varchar(100) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `cp` varchar(5) DEFAULT NULL,
  `provincia` varchar(100) DEFAULT NULL,
  `localidad` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nick` (`nick`),
  UNIQUE KEY `id` (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=30 ;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`id`, `email`, `password`, `roles`, `nick`, `rango`, `sexo`, `nombre`, `apellidos`, `direccion`, `cp`, `provincia`, `localidad`) VALUES
(28, 'admin@admin.com', 'nhDr7OyKlXQju+Ge/WKGrPQ9lPBSUFfpK+B1xqx/+8zLZqRNX0+5G1zBQklXUFy86lCpkAofsExlXiorUcKSNQ==', 'ROLE_USER', 'admin', 10, 1, 'Manuel', 'Pancorbo Pestaña', 'Molino, 13', '23640', 'Jaén', 'Torre del Campo'),
(29, 'sergio@gmail.com', 'DVW9Uk/9AUnG7zqtOXMnofH860FKgwzoIv1A/n3VmpaLD3RMgHydHj3sPy+aGQ7pMIJz0wY6hdiGHNVhUDh4xQ==', 'ROLE_USER', 'muriana', 0, 0, NULL, NULL, NULL, NULL, '', '');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
