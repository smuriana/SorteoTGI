-- phpMyAdmin SQL Dump
-- version 4.0.10
-- http://www.phpmyadmin.net
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-01-2014 a las 21:18:58
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `mensajeSistemaGanador`(IN `id` INT, IN `winnerNumber` INT)
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE varIdUser,varNumber INT;
  DECLARE tituloSorteo VARCHAR(200);
  DECLARE idSistema INT;
  DECLARE cursorParticipantes CURSOR FOR SELECT id_user, number FROM ballot WHERE id_ruffle=id;
  DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
  
  SET tituloSorteo = (SELECT title FROM ruffle WHERE ruffle.id=id);
  SET idSistema = (SELECT user.id FROM user WHERE user.nick='Sistema');
  OPEN cursorParticipantes;

  REPEAT
    FETCH cursorParticipantes INTO varIdUser, varNumber;

    IF NOT done THEN
       IF (varNumber = winnerNumber) THEN
       INSERT INTO conversation (id_user, id_user_to) VALUES (idSistema, varIdUser);          
       INSERT INTO notification (id_user, id_user_to, text, id_conversation) VALUES (idSistema, varIdUser, CONCAT("¡Enhorabuena ha ganado el sorteo ",tituloSorteo,"!"),LAST_INSERT_ID());
       ELSE
       INSERT INTO conversation (id_user, id_user_to) VALUES (idSistema, varIdUser);          
       INSERT INTO notification (id_user, id_user_to, text, id_conversation) VALUES (idSistema, varIdUser, CONCAT("Lo sentimos, pero esta vez no ha habido suerte en el sorteo ",tituloSorteo),LAST_INSERT_ID());
       END IF;
    END IF;
  UNTIL done END REPEAT;

  CLOSE cursorParticipantes;
END$$

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=24 ;

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
(21, 28, 8, 95, 0),
(22, 28, 38, 5, 0);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Volcado de datos para la tabla `conversation`
--

INSERT INTO `conversation` (`id`, `id_user`, `id_user_to`, `date`) VALUES
(7, 32, 28, '2014-01-22 21:05:54'),
(8, 42, 28, '2014-01-22 21:27:52'),
(9, 28, 31, '2014-01-23 18:59:07'),
(10, 43, 28, '2014-01-23 19:42:12'),
(11, 38, 28, '2014-01-23 19:44:14'),
(12, 38, 28, '2014-01-23 19:44:14'),
(13, 38, 28, '2014-01-23 19:47:31'),
(14, 38, 28, '2014-01-23 19:47:31'),
(15, 43, 28, '2014-01-23 19:56:36'),
(16, 43, 28, '2014-01-23 20:01:59'),
(17, 43, 28, '2014-01-23 20:03:08'),
(18, 43, 28, '2014-01-23 20:04:44');

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=66 ;

--
-- Volcado de datos para la tabla `notification`
--

INSERT INTO `notification` (`id`, `id_user`, `text`, `visible`, `time`, `title`, `id_user_to`, `id_conversation`, `dialog`) VALUES
(53, 32, 'Hola, estoy interesado en tu nexus 4, me gustaría obtener mas información antes de decidirme por comprar un número elevado de papeletas ;)', 0, '2014-01-22 21:05:54', '', 28, 7, 1),
(54, 42, 'Ola k ase?', 0, '2014-01-22 21:27:52', '', 28, 8, 1),
(55, 28, 'asasA', 0, '2014-01-23 00:53:04', '', 31, 9, 1),
(56, 28, 'hola campeón! probando acentos y eñes', 1, '2014-01-23 18:59:07', '', 31, 9, 0),
(57, 43, 'Se ha procesado a compra de la papeleta correctamente', 0, '2014-01-23 19:42:12', '', 28, 10, 1),
(58, 38, '¡Enhorabuena ha ganado el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!', 0, '2014-01-23 19:44:14', '', 28, 11, 1),
(59, 38, '¡Enhorabuena ha ganado el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!', 0, '2014-01-23 19:44:14', '', 28, 12, 1),
(60, 38, '¡Enhorabuena ha ganado el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!', 0, '2014-01-23 19:47:31', '', 28, 13, 1),
(61, 38, '¡Enhorabuena ha ganado el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!', 0, '2014-01-23 19:47:31', '', 28, 14, 1),
(62, 43, '¡Enhorabuena ha ganado el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!', 0, '2014-01-23 19:56:36', '', 28, 15, 1),
(63, 43, 'Lo sentimos, pero esta vez no ha habido suerte en el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES', 0, '2014-01-23 20:01:59', '', 28, 16, 1),
(64, 43, '¡Enhorabuena ha ganado el sorteo INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!', 0, '2014-01-23 20:03:08', '', 28, 17, 1),
(65, 43, '¡Enhorabuena ha ganado el sorteo <br><h4>INFO RAFAEL. MARTIN@SOROZNOMADERA. ES!</h4>', 0, '2014-01-23 20:04:44', '', 28, 18, 1);

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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=42 ;

--
-- Volcado de datos para la tabla `ruffle`
--

INSERT INTO `ruffle` (`id`, `create_date`, `user_id`, `description`, `short_description`, `status`, `bill`, `guarantee`, `init_date`, `final_date`, `ballots`, `price`, `picture1`, `picture2`, `picture3`, `tags`, `sold_ballots`, `title`, `winnerNumber`, `visible`) VALUES
(37, '2014-01-23 19:29:26', 31, ' Amplio piso en alquiler en Urbanización El Almendral.  Consta de 4 dormitorios,  3 armarios empotrados,  2 baños exteriores con bañera,  salón independiente con acceso a terraza de aproximadamente 10 m2,  cocina nueva amueblada con electrodomésticos,  lavadero.  2 ascensores.  Comunidad y agua incluida en el alquiler.  Con fácil salida a todas direcciones,  próximo al Hospital de Jerez,  al Centro Comercial Area Sur y Luz Shopping.  ¡LLÁMENOS! REF.  A3057. 4ª Planta. CE: G', ' Amplio piso en alquiler en Urbanización El Almendral.  Consta de 4 dormitorios,  3 armarios empotrados,  2 baños exteriores con bañera,  salón', 0, 0, 0, '2014-01-23 07:01:26', '2014-02-23 07:02:26', 100, 530, 'http://91.229.239.8/fg/1068/13/alquiler-de-pisos/El-almendral-106813605_1.jpg', 'http://91.229.239.8/fg/1068/13/alquiler-de-pisos/El-almendral-106813605_2.jpg', 'http://91.229.239.8/fg/1068/13/alquiler-de-pisos/El-almendral-106813605_3.jpg', '', 0, 'EL ALMENDRAL', NULL, 0),
(38, '2014-01-23 19:29:27', 33, ' casa de madera modelo Isla Tabarca de 114 m2 con 150 Mm de grosor gran salon,   baños, dos dormitorios, gran terraza,  critales climalit, suelos de parque, electricidad fontaneria sanitarios aire acondicionado calefación etc, lista para vivir puede ser suya por solo desde 277 € al mes todo una ganga a su alcance.  Consultenos precios no olvide que somos fabricantes y si no le agrada nuestros modelos le fabricamos su diseño personalizado, 634-097-298 instalamos en toda España sin aumento de precio.  soroznomadera. es', ' casa de madera modelo Isla Tabarca de 114 m2 con 150 Mm de grosor gran salon,   baños, dos dormitorios, gran terraza,  critales climalit, suelos de', 0, 0, 0, '2014-01-23 07:01:27', '2014-02-23 07:02:27', 100, 277, 'http://91.229.239.8/fg/444/36/casas-prefabricadas/INFO-rafael.martin@soroznomadera.es-44436724_1.jpg', 'http://91.229.239.8/fg/444/36/casas-prefabricadas/INFO-rafael.martin@soroznomadera.es-44436724_2.jpg', 'http://91.229.239.8/fg/444/36/casas-prefabricadas/INFO-rafael.martin@soroznomadera.es-44436724_3.jpg', '', 2, 'INFO RAFAEL. MARTIN@SOROZNOMADERA. ES', NULL, 1),
(39, '2014-01-23 19:29:29', 36, ' Se vende subwoofer marca Paigonet de 600 wats de potencia con tapa incluida de JBL de dos canales en perfecto estado. ', ' Se vende subwoofer marca Paigonet de 600 wats de potencia con tapa incluida de JBL de dos canales en perfecto estado.', 0, 0, 0, '2014-01-23 07:01:29', '2014-02-23 07:02:29', 100, 120, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'SE VENDE SUBWOOFER', NULL, 0),
(40, '2014-01-23 19:29:30', 32, ' Ordenadores de ocasion varias configuraciones,  primeras marcas,  garantia de 1 año y 8 dias de satisfaccion,  transporte incluido en todos nuestros precios.  Te lo enviamos a tu domicilio en 24/48hrs.  Atencion telefonica de 9 de la mañana hasta las 2 de la madrugada.   WWW. EUROPCS. ES, 1 GB de memoria, 80 Gbytes de disco duro', ' Ordenadores de ocasion varias configuraciones,  primeras marcas,  garantia de 1 año y 8 dias de satisfaccion,  transporte incluido en todos nuestros', 0, 0, 0, '2014-01-23 07:01:30', '2014-02-23 07:02:30', 100, 100, 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', 'http://sommelierexpress.com/wp-content/themes/juiced/img/thumbnail-default.jpg', '', 0, 'ENVIOS A DOMICILIO', NULL, 0),
(41, '2014-01-23 19:29:32', 28, ' Bicicleta DE PASEO ESTILO AMERICANAS EN LIQUIDACION  garantizada por la empresa con factura de compra.   www. bicicletasvaldayo. es    se envia a toda españa', ' Bicicleta DE PASEO ESTILO AMERICANAS EN LIQUIDACION  garantizada por la empresa con factura de compra.   www. bicicletasvaldayo. es    se envia a toda', 0, 0, 0, '2014-01-23 07:01:32', '2014-02-23 07:02:32', 100, 200, 'http://91.229.239.8/fg/816/20/bicicletas/Bicicleta-paseo-americanas-81620539_1.jpg', 'http://91.229.239.8/fg/816/20/bicicletas/Bicicleta-paseo-americanas-81620539_2.jpg', 'http://91.229.239.8/fg/816/20/bicicletas/Bicicleta-paseo-americanas-81620539_3.jpg', '', 0, 'BICICLETA PASEO AMERICANAS', NULL, 0);

--
-- Disparadores `ruffle`
--
DROP TRIGGER IF EXISTS `NumeroPremiadoSorteo`;
DELIMITER //
CREATE TRIGGER `NumeroPremiadoSorteo` AFTER UPDATE ON `ruffle`
 FOR EACH ROW IF NOT (NEW.winnerNumber <=> OLD.winnerNumber) THEN
CALL mensajeSistemaGanador(OLD.id, NEW.winnerNumber);
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
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=44 ;

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
(42, 'usu42@usu42.com', 'NtqotRBmkl3nG7+OlLmr6kZH9RegOvJ4ZbjuKqLNkcepU7sWpeIp6R6SQw+Yek2CHKbhtC4SrovdagoM+kO3/Q==', 'ROLE_USER', 'Nuals1931', 3, 1, 'Raidis', 'Nino', 'Alcon Molina 91', '31010', 'Navarre', 'Barañain', '0000-00-00 00:00:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg'),
(43, 'sistema@sistema.com', 'Re+FtHSqWViyWvgBh3Rh3jmyEB2d0Y6Qe+cF6WT1gU+TGwK22dlA+MNbNuyZ5xYmcHMRMEO9vAGtd2C7aLgsWQ==', 'ROLE_USER', 'Sistema', 0, NULL, NULL, NULL, NULL, NULL, NULL, '', '2014-01-23 19:02:00', 'http://www.tontuna.com/wp-content/uploads/2012/10/cara-o-perfil.jpg');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
