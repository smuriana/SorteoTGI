-- phpMyAdmin SQL Dump
-- version 4.0.4.1
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-01-2014 a las 23:13:44
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Volcado de datos para la tabla `notification`
--

INSERT INTO `notification` (`id`, `id_user`, `url`, `text`, `visible`, `time`) VALUES
(8, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 4 para el sorteo de Audi A4', 0, '2013-12-28 19:57:39'),
(9, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 37 para el sorteo de Audi A4', 0, '2013-12-28 19:58:00'),
(10, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 0 para el sorteo de Audi A4', 0, '2013-12-28 20:35:23'),
(11, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 34 para el sorteo de Audi A4', 0, '2013-12-28 20:35:55'),
(12, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 12 para el sorteo de Audi A4', 0, '2013-12-28 20:37:06'),
(13, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 31 para el sorteo de Audi A4', 0, '2013-12-28 20:37:49'),
(14, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 2 para el sorteo de Audi A4', 0, '2013-12-28 20:46:15'),
(15, 28, '/descripcion/2/Audi A4', 'Has comprado la papeleta número 5 para el sorteo de Audi A4', 0, '2013-12-28 20:49:23');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ruffle`
--

CREATE TABLE IF NOT EXISTS `ruffle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` int(11) NOT NULL,
  `short_description` varchar(160) NOT NULL,
  `description` varchar(10000) NOT NULL,
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcado de datos para la tabla `ruffle`
--

INSERT INTO `ruffle` (`id`, `create_date`, `user_id`, `short_description`, `description`, `status`, `bill`, `guarantee`, `init_date`, `final_date`, `ballots`, `price`, `picture1`, `picture2`, `picture3`, `tags`, `sold_ballots`, `title`) VALUES
(1, '2013-11-20 19:30:21', 28, 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.', 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.\n\nLo vendo por haber adquirido el nuevo nexus 5', 9, 0, 0, '2013-11-20 23:00:00', '2013-11-26 23:00:00', 100, 300, '/img/nexus1.jpg', '/img/nexus2.jpg', '/img/nexus1.jpg', 'nexus 4, móvil, smartphone', 42, 'Sorteo Nexus 4'),
(2, '2013-12-21 01:30:40', 29, 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km. El coche esta en perfecto estado', 'AUDI A4 1.9 TDI, verde, año 2004, 160000 km, 6900 eur., El coche esta en perfecto estado , mejor verlo y probarlo , tiene todo al día , libro de revisiones sellado en la casa audi . con todas las facturas , correas de distribución , filtros , pastillas ect...\r\nLo vendo por aumento de familia , acepto prueba mecánica , el coche esta como nuevo a tenido un mantenimiento excelente y siempre se le a echado diésel ultimate .\r\nTodos lo extras ESP,ordenador de abordo , doble clima ect...', 1, 1, 0, '2013-12-20 23:00:00', '2013-12-27 23:00:00', 100, 6900, '/img/audi1.jpg', '/img/audi2.jpg', '', '', 0, 'Audi A4'),
(3, '2013-12-21 01:36:15', 28, 'Precintado + 16 GB + Libre + Plateado y Blanquito!', 'El nuevo IPHONE 5S, es el modelo de 16 GB precintado y en color BLANCO Y PLATA. Lo tengo en mi poder y se envia al dia siguiente del sorteo directamente al ganador. ', 1, 1, 1, '2013-12-20 23:00:00', '2013-12-30 23:00:00', 100, 700, '/img/iphone1.jpg', '/img/iphone2.jpg', '', '', 0, 'Iphone 5S de 16GB Libre');

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
