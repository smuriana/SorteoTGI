<?php
include_once('simple_html_dom.php');
// date(N) Representación numérica del día de la semana, 1 (para lunes) hasta 7 (para domingo)
$diaSemanal = date("N");

// De lunes a jueves es el cupon diario
if ($diaSemanal < 5){
	$tipoSorteo = "N";
// Viernes es el cuponazo
}else if ($diaSemanal == 5){
	$tipoSorteo = "V";
}else{
// Sabados y domingos es el sueldazo
	$tipoSorteo = "D";
}

$hoy = date("Ymd");
// Parseo de la url para obtener el número premiado 
$url = 'http://www.juegosonce.es/wmx/dicadi/pub/premEstadistic/detalleEscrutiniocupon.cfm?fecha='.$hoy.'&tiposorteo='.$tipoSorteo;
// Guardamos en una variable el resultado de la peticion a la url y buscamos el número ganador
$html = file_get_html($url);
$search[]=' ';//busqueda de espacios
$search[]='	';//Busquedade tabuladores
$resultado= str_replace($search, '', $html->find('div[class=saltoLinea]')[0]->plaintext);
// Limpiamos la variable para no tener perdidas de memoria
$html->clear();
unset($html);
// Actualizamos en la base de datos los sorteos que han finalizado hoy
if(is_object($resultado)){
    $conexion = mysql_connect("localhost", "admin", "admin");
    mysql_select_db("sorteos_db", $conexion);
    $hoy = date("Y-m-d");
    $queEmp = "UPDATE ruffle SET winnerNumber = ".$resultado." WHERE final_date = '".$hoy."'";
    $resEmp = mysql_query($queEmp, $conexion) or die(mysql_error());
    $totEmp = mysql_num_rows($resEmp);
}





?>