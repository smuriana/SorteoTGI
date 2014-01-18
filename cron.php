<?php
include_once('simple_html_dom.php');


// 2. create HTML Dom

$html = file_get_html('http://www.juegosonce.es/wmx/dicadi/pub/premEstadistic/detalleEscrutiniocupon.cfm?fecha=20140115');
$search[]=' ';//busqueda de espacios
$search[]='	';//Busquedade tabuladores
$resultado= str_replace($search, '', $html->find('div[class=saltoLinea]')[0]->plaintext);
//echo $resultado;
$html->clear();
unset($html);

    $conexion = mysql_connect("localhost", "admin", "admin");
    mysql_select_db("sorteos_db", $conexion);
    $hoy = date("Y-m-d");
    echo $hoy;
    $queEmp = "UPDATE ruffle SET winnerNumber = ".$resultado." WHERE final_date = '".$hoy."'";
    $resEmp = mysql_query($queEmp, $conexion) or die(mysql_error());
    $totEmp = mysql_num_rows($resEmp);





?>