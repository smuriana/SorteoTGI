-- phpMyAdmin SQL Dump
-- version 4.0.10
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-12-2013 a las 18:19:16
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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ballot`
--

CREATE TABLE IF NOT EXISTS `ballot` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_ruffle` int(11) NOT NULL,
  `number` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `ballot`
--

INSERT INTO `ballot` (`id`, `id_user`, `id_ruffle`, `number`) VALUES
(0, 28, 1, 1),
(1, 28, 1, 1);

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcado de datos para la tabla `ruffle`
--

INSERT INTO `ruffle` (`id`, `create_date`, `user_id`, `description`, `short_description`, `status`, `bill`, `guarantee`, `init_date`, `final_date`, `ballots`, `price`, `picture1`, `picture2`, `picture3`, `tags`, `sold_ballots`, `title`) VALUES
(1, '2013-11-20 19:30:21', 28, 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.\n\nLo vendo por haber adquirido el nuevo nexus 5', 'Nexus 4 en perfecto estado. Uso diario de 4 meses. Con funda y protector desde el primer día.', 9, 0, 0, '2013-11-20 23:00:00', '2013-11-26 23:00:00', 100, 300, '/img/nexus1.jpg', '/img/nexus1.jpg', '/img/nexus1.jpg', 'nexus 4, móvil, smartphone', 42, 'Sorteo Nexus 4');

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
