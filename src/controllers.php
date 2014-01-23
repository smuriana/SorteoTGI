<?php
include_once('../simple_html_dom.php');
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Security\Core\Encoder\MessageDigestPasswordEncoder;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpKernel\HttpKernelInterface;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;
use App\Ruffle\Ruffle;
$app->get('/', function () use ($app) {
	return $app->redirect('index');
})
->bind('homepage')
;




$app->get('/bbdd/{numTuplas}/{tabla}', function($numTuplas, $tabla) use ($app){

	if($tabla=='user'){
		
		$encoder = new MessageDigestPasswordEncoder();
		
		$sql = "SELECT max(id) FROM ".$tabla;
    	$punteroId = $app['db']->fetchAll($sql);
    	$punteroId = $punteroId[0]["max(id)"]+1;

		// Cargamos un csv con 100 datos falsos generados en http://es.fakenamegenerator.com
		$i=0;
		if (($handle = fopen("../usuarios.csv", "r")) !== FALSE) {
		    while (($dato = fgetcsv($handle, 1000, ",")) !== FALSE AND ($i < $numTuplas)) {

		       		$usuarioActual = 'usu'.($punteroId+$i);
				    $array = array(
						"email" => $usuarioActual."@".$usuarioActual.'.com',
						"password" => $encoder->encodePassword($usuarioActual, ''),
						"roles" => "ROLE_USER",
						"nick" => $dato[0],
						"rango" => rand(0, 5),
						"sexo" => str_replace(array('female','male'), array('0','1'), $dato[1]),
						"nombre" => $dato[2],
						"apellidos" => $dato[3],
						"direccion" => $dato[4],
						"cp" => $dato[5],
						"provincia" => $dato[6],
						"localidad" => $dato[7],
						"registerDate" => date("Y:M:D h:m:s"),

					);
				    print_r($app['db']->insert('user', $array));
			        $i++;
		    }
		    fclose($handle);
		}
		
	}
	if($tabla=='ruffle'){
		$NUMERO_SORTEOS=$numTuplas;
		$NUMERO_PAGINAS=50;
		$SORTEOS_POR_PAGINA=2;
		$PRODUCTOS_POR_PAGINA=29;
		$REGION="andalucia";
		$PRECIO_MINIMO=100;
		$PRECIO_MAXIMO=900;
		$ORDEN="barato";

		for ($i=0; $i < $NUMERO_SORTEOS/$SORTEOS_POR_PAGINA; $i++) { 
			$pagina=rand(1,$NUMERO_PAGINAS);
			//$url = 'http://www.milanuncios.com/anuncios-en-'.$REGION.'/?desde='.$PRECIO_MINIMO.'&hasta='.$PRECIO_MAXIMO.'&orden='.$ORDEN.'&pagina='.$pagina;
			$url = 'http://www.milanuncios.com/anuncios-en-'.$REGION.'/?desde='.$PRECIO_MINIMO.'&hasta='.$PRECIO_MAXIMO.'&pagina='.$pagina;
			$html = file_get_html($url);
			$titulos= $html->find('div[class=x7] a[class=cti]');
			$descripciones= $html->find('div[class=x7] div[class=tx]');
			$precios= $html->find('div[class=x7] div[class=x11] div[class=pr]');
			$aleatorio=rand(0,$PRODUCTOS_POR_PAGINA-$SORTEOS_POR_PAGINA);
			
			for ($j=$aleatorio; $j < $aleatorio+$SORTEOS_POR_PAGINA; $j++) { 
				$array['title']=$titulos[$j]->plaintext;
				//echo '<b>'.$titulos[$j]->plaintext.'</b><br>'; 
				
				$array['description']=$descripciones[$j]->plaintext;

				$descripcionCorta= substr($descripciones[$j]->plaintext, 0, 157);
				$indiceUltimoEspacio = strrpos($descripcionCorta," ");
				$array['short_description']=substr($descripcionCorta, 0, $indiceUltimoEspacio);

				//echo substr($descripcionCorta, 0, $indiceUltimoEspacio).'...<br>';
				//echo $descripciones[$j]->plaintext.'<br>'; 
				
				$indiceEuro = strrpos($precios[$j]->plaintext,"precio");
				$array['price']=substr($precios[$j]->plaintext, 0, $indiceEuro-1); 
				//echo substr($precios[$j]->plaintext, 0, $indiceEuro-1).'<br>'; 

				$url='http://www.milanuncios.com'.$titulos[$j]->href;
				$html = file_get_html($url);
				$fotos= $html->find('div[class=pagAnuFotoBox] div[class=pagAnuFoto] img');
				array_splice($fotos, 3); //Dejamos solo 3 fotos
				$cont=1;
				foreach ($fotos as $foto) {
					$array['picture'.$cont]=$foto->src;
					//echo $foto->src.'<br>';
					$cont++;
				}

				if(!empty($array)){
					$fechaCreacion = date("Y-m-d h:m:s");
					$fechaFinalizacion = date("Y-m-d h:m:s", strtotime("+1 months", strtotime($fechaCreacion)));
					$array['init_date']=$fechaCreacion;
					$array['final_date']=$fechaFinalizacion;

					$array['ballots']=100;
					$array['sold_ballots']=0;
					$array['bill']=0;
					$array['guarantee']=0;
					
					$sql = "SELECT id FROM user";
					$resultado=$app['db']->fetchAll($sql);
					$usuarioAleatorio=rand(0,count($resultado));
					$array['user_id']=$resultado[$usuarioAleatorio]["id"];
					print_r($app['db']->insert('ruffle', $array));
				}
				unset($array);
				$array = array();
			}
			$html->clear();
			unset($html);
		}
		    	
	}	
	$user = $app['security']->getToken()->getUser();
	// Devuelve todos los sorteos comenzados y los guarda en un array los sortos inicializados
	$hoy = date("Y-m-d H:i:s");
	$sql = "SELECT id FROM ruffle WHERE final_date > '".$hoy."' AND init_date < '".$hoy."'";
    $ruffles = $app['db']->fetchAll($sql);
    
    $allRuffles= array();
    foreach ($ruffles as $sorteo) {
    	$allRuffles[]=new Ruffle($sorteo['id'], $app['db']);
    }

	$sql = "SELECT COUNT(*) FROM notification WHERE id_user_to = ".$user->getId();
    $notifications = $app['db']->fetchAll($sql);
	
	return $app['twig']->render('index.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'user' => $user,
		'ruffles' => $allRuffles,
		'menu_selected' => 'index'
		));
})
->bind('bbdd')
;
$app->get('/index', function() use ($app){

	$user = $app['security']->getToken()->getUser();
	// Devuelve todos los sorteos comenzados y los guarda en un array los sortos inicializados
	$sql = "SELECT * FROM ruffle WHERE visible = 1";
    $ruffles = $app['db']->fetchAll($sql);
        
	if(!is_object($user)){
		return $app['twig']->render('index.twig.html', array(
		'notifications' => null,
		'notificationsDialog' =>null,
		'name' => null,
		'ruffles' => $ruffles,
		'menu_selected' => 'index'
		));
	}

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));
	
	return $app['twig']->render('index.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'user' => $user,
		'ruffles' => $ruffles,
		'menu_selected' => 'index'
		));
})
->bind('index')
;

$app->get('/descripcion/{id}/{title}', function($id, $title) use ($app){

	$user = $app['security']->getToken()->getUser();
	
    $myRuffle = new Ruffle($id,$app['db']);//Esto no creemos que este demasiado bien
    
    $userSorteo = $app['db']->fetchAssoc('SELECT user.* FROM user, ruffle WHERE user.id = ruffle.user_id AND ruffle.id = ?', array($id));

    $valoracionMedia = $app['db']->fetchAssoc('SELECT AVG(general) as media FROM opinion WHERE id_user = ?', array($userSorteo['id']));

    $totalValoraciones = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ?', array($userSorteo['id']));

    $totalValoraciones5 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 5', array($userSorteo['id']));

    $totalValoraciones4 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 4', array($userSorteo['id']));

    $totalValoraciones3 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 3', array($userSorteo['id']));

    $totalValoraciones2 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 2', array($userSorteo['id']));

    $totalValoraciones1 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 1', array($userSorteo['id']));

    $opiniones = $app['db']->fetchAll('SELECT user.picture, user.nick, opinion.comentario FROM user, opinion WHERE user.id = opinion.id_user_opina AND opinion.id_user = ?', array($userSorteo['id']));


    // date(N) RepresentaciÃ³n numÃ©rica del dÃ­a de la semana, 1 (para lunes) hasta 7 (para domingo)
	$diaSemanal = date("N", strtotime($myRuffle->getFinalDate()));
	
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
	$hoy = date("Ymd", strtotime($myRuffle->getFinalDate()));
    $urlONCE = 'http://www.juegosonce.es/wmx/dicadi/pub/premEstadistic/detalleEscrutiniocupon.cfm?fecha='.$hoy.'&tiposorteo='.$tipoSorteo;

    $papeletaPremiada=substr($myRuffle->getWinnerNumber(), 3, 5);
   
	$papeletaPremiada = intval($papeletaPremiada);
	

    $idPremiado = $app['db']->fetchAssoc('SELECT id_user FROM ballot WHERE number = ? AND id_ruffle = ? AND status = 2', array($papeletaPremiada,$myRuffle->getID()));

    $userPremiado = $app['db']->fetchAssoc('SELECT * FROM user WHERE user.id = ?', array($idPremiado['id_user']));

	if(!is_object($user)){
		return $app['twig']->render('descripcionSorteo.twig.html', array(
		'notifications' => null,
		'notificationsDialog' =>null,
		'notificationsDialog' =>null,
		'name' => null,
		'ruffle' => $myRuffle,
		'userSorteo' => $userSorteo,
		'userPremiado' => $userPremiado,
		'valoracionMedia' => $valoracionMedia,
    	'totalValoraciones' => $totalValoraciones,
    	'totalValoraciones5' => $totalValoraciones5,
    	'totalValoraciones4' => $totalValoraciones4,
    	'totalValoraciones3' => $totalValoraciones3,
    	'totalValoraciones2' => $totalValoraciones2,
    	'totalValoraciones1' => $totalValoraciones1,
    	'opiniones' => $opiniones,
		'menu_selected' => 'null',
		'urlONCE' => $urlONCE
		));
	}

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));



	return $app['twig']->render('descripcionSorteo.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'user' => $user,
		'ruffle' => $myRuffle,
		'userSorteo' => $userSorteo,
		'userPremiado' => $userPremiado,
		'valoracionMedia' => $valoracionMedia,
    	'totalValoraciones' => $totalValoraciones,
    	'totalValoraciones5' => $totalValoraciones5,
    	'totalValoraciones4' => $totalValoraciones4,
    	'totalValoraciones3' => $totalValoraciones3,
    	'totalValoraciones2' => $totalValoraciones2,
    	'totalValoraciones1' => $totalValoraciones1,
    	'opiniones' => $opiniones,
		'menu_selected' => 'null',
		'urlONCE' => $urlONCE
		));
})
->bind('descripcion')
;

$app->get('/admin/descripcion/{id}/{title}', function($id, $title) use($app){

	$user = $app['security']->getToken()->getUser();
	
    $myRuffle = new Ruffle($id,$app['db']);//Esto no creemos que este demasiado bien

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));

    $userSorteo = $app['db']->fetchAssoc('SELECT user.* FROM user, ruffle WHERE user.id = ruffle.user_id AND ruffle.id = ?', array($id));

    $valoracionMedia = $app['db']->fetchAssoc('SELECT AVG(general) as media FROM opinion WHERE id_user = ?', array($userSorteo['id']));

    $totalValoraciones = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ?', array($userSorteo['id']));

    $totalValoraciones5 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 5', array($userSorteo['id']));

    $totalValoraciones4 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 4', array($userSorteo['id']));

    $totalValoraciones3 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 3', array($userSorteo['id']));

    $totalValoraciones2 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 2', array($userSorteo['id']));

    $totalValoraciones1 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 1', array($userSorteo['id']));

	return $app['twig']->render('descripcionAdminSorteo.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'user' => $user,
		'ruffle' => $myRuffle,
		'userSorteo' => $userSorteo,
		'valoracionMedia' => $valoracionMedia,
    	'totalValoraciones' => $totalValoraciones,
    	'totalValoraciones5' => $totalValoraciones5,
    	'totalValoraciones4' => $totalValoraciones4,
    	'totalValoraciones3' => $totalValoraciones3,
    	'totalValoraciones2' => $totalValoraciones2,
    	'totalValoraciones1' => $totalValoraciones1,
		'menu_selected' => 'null'
		));
})
->bind('descripcionAdmin')
;

$app->get('/admin/validate/{id}/{title}', function($id, $title) use($app){
	
    $usuarios = $app['db']->executeUpdate('UPDATE ruffle SET visible = 1 WHERE id = ?', array($id));

	return $app->redirect('../../../descripcion/'.$id.'/'.$title);    
})
->bind('validate')
;

$app->get('/admin/refused/{id}', function($id) use($app){
	
    $app['db']->executeUpdate('UPDATE ruffle SET visible = 3 WHERE id = ?', array($id));

	return $app->redirect('../../admin');    
})
->bind('refused')
;

$app->get('/admin/cancel/{id}', function($id) use ($app){

	$app['db']->executeUpdate('UPDATE ruffle SET visible = 4 WHERE id = ?', array($id));
	$app['db']->executeUpdate('UPDATE ballot SET status = 1 WHERE id_ruffle = ?', array($id));

	return $app->redirect('../../admin');
})
->bind('cancel')
;

$app->get('/admin/reintegrar/{idUser}/{idSorteo}', function($idUser, $idSorteo) use ($app){

	$app['db']->executeUpdate('UPDATE ballot SET status = 2 WHERE id_user = ? AND id_ruffle = ?', array($idUser, $idSorteo));

	return $app->redirect('../../../admin');
})
->bind('reintegrar')
;

$app->get('/admin', function(Request $request) use ($app){
	$user = $app['security']->getToken()->getUser();

    $notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
    $notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));

    $sqlSorteosPorValidar = "SELECT ruffle.id, ruffle.title, ruffle.price, user.nick FROM ruffle, user WHERE ruffle.visible = 0 AND ruffle.user_id=user.id";
    $sorteosPorValidar = $app['db']->fetchAll($sqlSorteosPorValidar);
    
    $sqlSorteosTerminados = "SELECT ruffle.id, ruffle.title, ruffle.price, user.nick FROM ruffle, user WHERE ruffle.visible = 2 AND ruffle.user_id=user.id";
    $sorteosTerminados = $app['db']->fetchAll($sqlSorteosTerminados);
    
    $sqlSorteosDisponibles = "SELECT ruffle.id, ruffle.title, ruffle.price, user.nick FROM ruffle, user WHERE ruffle.visible = 1 AND ruffle.user_id=user.id";
    $sorteosDisponibles = $app['db']->fetchAll($sqlSorteosDisponibles);
    
    $sqlUsuarios = "SELECT nick, registerDate, roles FROM user ORDER BY roles DESC";
    $usuarios = $app['db']->fetchAll($sqlUsuarios);
    
    $sqlFecha = "SELECT final_date FROM ruffle WHERE visible = 1 ORDER BY final_date DESC";
    $fecha = $app['db']->fetchAssoc($sqlFecha);
    
	$sqlRecaudado = "SELECT SUM(sold_ballots*(price/ballots)) as cantidad FROM ruffle";
    $recaudacion = $app['db']->fetchAssoc($sqlRecaudado);

	$sqlPapeletas = "SELECT SUM(sold_ballots) as numPapeletas FROM ruffle";
    $papeletas = $app['db']->fetchAssoc($sqlPapeletas);

    $sqlPapeletasReintegrar = "SELECT user.id, user.nick, ruffle.id as id_ruffle, ruffle.title, COUNT(*) as cantidad FROM ballot, ruffle, user WHERE ballot.id_ruffle = ruffle.id AND ruffle.visible = 4 AND ballot.id_user = user.id AND ballot.status = 1 GROUP BY(user.nick);";
    $papeletasReintegrar = $app['db']->fetchAll($sqlPapeletasReintegrar);

    $sqlNumUsuarios = "SELECT COUNT(id) as cantidad FROM user";
    $numUsuarios = $app['db']->fetchAssoc($sqlNumUsuarios);
    
	return $app['twig']->render('dashboardAdmin.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'notificationsDialog' => $notificationsDialog,
		'sorteosPorValidar' => $sorteosPorValidar,
		'sorteosTerminados' => $sorteosTerminados,
		'sorteosDisponibles' => $sorteosDisponibles,
		'usuarios' => $usuarios,
		'user' => $user,
		'fecha' => $fecha,
		'recaudacion' => $recaudacion,
		'papeletas' => $papeletas,
		'papeletasReintegrar' => $papeletasReintegrar,
		'numUsuarios' => $numUsuarios,
		'menu_selected' => 'admin'
		));
})
->bind('admin')
;
$app->post('/buyTicket', function(Request $request) use($app){

	$user = $app['security']->getToken()->getUser();
	$app['db']->insert('ballot', array('id_user' => $user->getID(), 'id_ruffle' => $request->get('RuffleID'), 'number' => $request->get('number')));
	$app['db']->insert('notification', array('id_user' => $user->getID(), 'url' => '/descripcion/'.$request->get('RuffleID').'/'.$request->get('name'), 'text' => 'Has comprado la papeleta número '.$request->get('number').' para el sorteo de '.$request->get('name'), 'visible' => true));
	return $app->redirect('index');
})
->bind('buyTicket');

$app->match('/login', function (Request $request) use ($app) {

	$user = $app['security']->getToken()->getUser();

	if(!is_object($user)){
		return $app['twig']->render('login.twig.html', array(
			'invalidEmail' => false,
			'invalidNick' => false,
			'error' => $app['security.last_error']($request),
			'last_username' => $app['session']->get('_security.last_username'),	
			'name' => null,
			'menu_selected' => 'null'
    		));
	}
    
    return $app->redirect('perfil');
})
->method('GET|POST')
->bind('login')
;

$app->get('/nuevoSorteo', function(Request $request) use ($app){
	$user = $app['security']->getToken()->getUser();

    $notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
    $notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));


	if(!is_object($user)){
		return $app['twig']->render('sorteoNuevo.twig.html', array(
		'notifications' => null,
		'notificationsDialog' =>null,
		'name' => null,
		'menu_selected' => 'nuevoSorteo'
		));
	}

	return $app['twig']->render('sorteoNuevo.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'user' => $user,
		'menu_selected' => 'nuevoSorteo'
		));
})
->bind('nuevoSorteo')
;
$app->get('/sorteosTerminados', function(Request $request) use ($app){
$user = $app['security']->getToken()->getUser();
	// Devuelve todos los sorteos comenzados y los guarda en un array los sortos inicializados
	$hoy = date("Y-m-d H:i:s");
	$sql = "SELECT id FROM ruffle WHERE visible = 2";
    $ruffles = $app['db']->fetchAll($sql);
    
    $allRuffles= array();
    foreach ($ruffles as $sorteo) {
    	$allRuffles[]=new Ruffle($sorteo['id'], $app['db']);
    }
    $myRuffle = new Ruffle(1, $app['db']);
    
	if(!is_object($user)){
		return $app['twig']->render('index.twig.html', array(
		'notifications' => null,
		'notificationsDialog' =>null,
		'debug' => true,
		'name' => null,
		'ruffles' => $allRuffles,
		'menu_selected' => 'sorteosTerminados'
		));
	}

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));
	
	return $app['twig']->render('index.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'user' => $user,
		'ruffles' => $allRuffles,
		'menu_selected' => 'sorteosTerminados'
		));
})
->bind('sorteosTerminados')
;

$app->get('/perfil', function(Request $request) use($app){

	
	$user = $app['security']->getToken()->getUser();

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));
    
    $sorteosCreados = $app['db']->fetchAll('SELECT ruffle.* FROM ruffle, user WHERE ruffle.user_id = user.id AND user.nick = ?', array($user->getNick()));

    $usuario = $app['db']->fetchAssoc('SELECT * FROM user WHERE user.nick = ?', array($user->getNick()));

    $valoracionMedia = $app['db']->fetchAssoc('SELECT AVG(general) as media FROM opinion WHERE id_user = ?', array($user->getId()));

    $totalValoraciones = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ?', array($user->getId()));

    $totalValoraciones5 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 5', array($user->getId()));

    $totalValoraciones4 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 4', array($user->getId()));

    $totalValoraciones3 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 3', array($user->getId()));

    $totalValoraciones2 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 2', array($user->getId()));

    $totalValoraciones1 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 1', array($user->getId()));

    $opiniones = $app['db']->fetchAll('SELECT user.picture, user.nick, opinion.comentario FROM user, opinion WHERE user.id = opinion.id_user_opina AND opinion.id_user = ?', array($user->getId()));

    $sorteosParticipa = $app['db']->fetchAll('SELECT DISTINCT ruffle.* FROM ruffle, ballot WHERE ballot.id_user = ruffle.user_id AND ruffle.user_id = ?', array($user->getId()));

    return $app['twig']->render('profile.twig.html', array(
    	'notifications' => $notifications,
    	'notificationsDialog' => $notificationsDialog,
    	'userPerfil' => $usuario,
    	'user' => $user,
    	'email'=> $user->getUsername(),
    	'menu_selected' => 'perfil',
    	'fichas' => $sorteosCreados,
    	'sorteosParticipa' => $sorteosParticipa,
    	'valoracionMedia' => $valoracionMedia,
    	'totalValoraciones' => $totalValoraciones,
    	'totalValoraciones5' => $totalValoraciones5,
    	'totalValoraciones4' => $totalValoraciones4,
    	'totalValoraciones3' => $totalValoraciones3,
    	'totalValoraciones2' => $totalValoraciones2,
    	'totalValoraciones1' => $totalValoraciones1,
    	'opiniones' => $opiniones,
    	));

})
->bind('perfil')
;

$app->get('/perfil/{nick}', function($nick) use($app){

    $user = $app['security']->getToken()->getUser();
    if($nick == $user->getNick()){
            return $app->redirect('../perfil');
    }

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));

    $id = $app['db']->fetchAssoc('SELECT id from user WHERE nick = ?', array($nick));
    
    $ruffles = $app['db']->fetchAll('SELECT ruffle.* FROM ruffle, user WHERE ruffle.user_id = user.id AND user.nick = ?', array($nick));

    $usuario = $app['db']->fetchAssoc('SELECT user.nick, user.picture, user.rango, user.id FROM user WHERE user.nick = ?', array($nick));

    $valoracionMedia = $app['db']->fetchAssoc('SELECT AVG(general) as media FROM opinion WHERE id_user = ?', array($id['id']));

    $totalValoraciones = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ?', array($id['id']));

    $totalValoraciones5 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 5', array($id['id']));

    $totalValoraciones4 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 4', array($id['id']));

    $totalValoraciones3 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 3', array($id['id']));

    $totalValoraciones2 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 2', array($id['id']));

    $totalValoraciones1 = $app['db']->fetchAssoc('SELECT Count(general) as total FROM opinion WHERE id_user = ? AND general = 1', array($id['id']));

    $opiniones = $app['db']->fetchAll('SELECT user.picture, user.nick, opinion.comentario FROM user, opinion WHERE user.id = opinion.id_user_opina AND opinion.id_user = ?', array($id['id']));

    return $app['twig']->render('perfilPublico.twig.html', array(
    	'notifications' => $notifications,
    	'notificationsDialog' => $notificationsDialog,
    	'user' => $user,
    	'email'=> $user->getUsername(),
    	'menu_selected' => 'perfil',
    	'fichas' => $ruffles,
    	'userPerfil' => $usuario,
    	'valoracionMedia' => $valoracionMedia,
    	'totalValoraciones' => $totalValoraciones,
    	'totalValoraciones5' => $totalValoraciones5,
    	'totalValoraciones4' => $totalValoraciones4,
    	'totalValoraciones3' => $totalValoraciones3,
    	'totalValoraciones2' => $totalValoraciones2,
    	'totalValoraciones1' => $totalValoraciones1,
    	'opiniones' => $opiniones,

    	));

})
->bind('perfilPublico')
;

$app->post('/register', function(Request $request) use ($app){

	$sql = "SELECT * FROM user WHERE email = ?";
    $res = $app['db']->fetchAll($sql, array($request->get('email')));

    $res2 =$app['db']->fetchAll("SELECT * FROM user WHERE nick = ?", array($request->get('nick')));

  	if(count($res2) === 1){
  		return $app['twig']->render('login.twig.html', array('invalidEmail' => false,'menu_selected' => 'null','invalidNick' => true));
  	}

    if(count($res) === 1){
    	return $app['twig']->render('login.twig.html', array('invalidEmail' => true,'menu_selected' => 'null','invalidNick' => false));
    }


	$encoder = new MessageDigestPasswordEncoder();
	$encodePass = $encoder->encodePassword($request->get('password'), '');
	$app['db']->insert('user', array('email' => $request->get('email'), 'password' => $encodePass, 'nick' => $request->get('nick'), 'roles' => 'ROLE_USER'));

	$params = array(
		'email' => $request->get('email'),
		'password' => $request->get('password')
		);
	$subRequest = Request::create('/login_check', 'POST', $params);


	$response = $app->handle($subRequest, HttpKernelInterface::SUB_REQUEST);
    return $app->redirect('index');


})
->bind('register')
;

$app->get('/misMensajes', function() use ($app){

	$user = $app['security']->getToken()->getUser();
    $app['db']->update('notification',array('visible' => 0), array('visible' => 1, 'id_user_to' => $user->getId()));
    $app['db']->update('notification',array('dialog' => 1), array('dialog' => 0, 'id_user_to' => $user->getId()));
	if(!is_object($user)){
		return $app['twig']->render('mensajes.twig.html', array(
		'notifications' => null,
		'notificationsDialog' =>null,
		'name' => null,
		'menu_selected' => 'null'
		));
	}

	$notifications = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE visible = 1 AND id_user_to =?", array($user->getId()));
	$notificationsDialog = $app['db']->fetchAssoc("SELECT COUNT(*) as total FROM notification WHERE dialog = 0 AND id_user_to =?", array($user->getId()));
    
    $app['db']->update('notification',array('dialog' => 1),	array('id_user_to'	=> $user->getId(),'dialog' => 0	));

    $conversations = $app['db']->fetchAll('SELECT conversation.id, conversation.date, user.nick FROM conversation, user WHERE (conversation.id_user = ? OR conversation.id_user_to = ?) AND ((user.id <> ?) AND (user.id = conversation.id_user_to OR user.id = conversation.id_user)) ORDER BY date DESC', array($user->getId(), $user->getId(), $user->getId()));
    $mensajes = array();
    foreach ($conversations as $conversation) {
    	$mensajesAux = $app['db']->fetchAll('SELECT user.nick, user.picture, user.id, notification.text, notification.time, notification.id as notificationid FROM notification, user WHERE notification.id_conversation = ? AND user.id = notification.id_user ORDER BY notification.time DESC', array($conversation['id']));
    	array_push($mensajes, $mensajesAux);
    }

	return $app['twig']->render('mensajes.twig.html', array(
		'notifications' => $notifications,
		'notificationsDialog' => $notificationsDialog,
		'conversations' => $conversations,
		'mensajes' => $mensajes,
		'user' => $user,
		'menu_selected' => 'null'
		));

})
->bind('misMensajes')
;

$app->post('/creaSorteo', function(Request $request) use ($app){

	$user = $app['security']->getToken()->getUser();
	
	if ($request->get('bill')=='bill'){
		$bill = 1;
	}else{
		$bill = 0;
	}

	if ($request->get('guarantee') == 'guarantee'){
		$guarantee = 1;
	}else{
		$guarantee = 0;
	}
	$app['db']->insert('ruffle', array(
		'user_id' 			=> $user->getId(),
		'description' 		=> $request->get('description'),
		'short_description' => $request->get('short_description'),
		'bill' 				=> $bill,
		'guarantee' 		=> $guarantee,
		'init_date' 		=> $request->get('init_date'),
		'final_date' 		=> $request->get('finish_date'),
		'ballots'			=> $request->get('numBallots'),
		'price'				=> $request->get('price'),
		'picture1'			=> $request->get('photo1'),
		'picture2'			=> $request->get('photo2'),
		'picture3'			=> $request->get('photo3'),
		'title'				=> $request->get('title'),
				));
		
	return $app->redirect('index');
})
->bind('creaSorteo')
;

$app->post('/crearConversacion', function(Request $request) use ($app){

	$user = $app['security']->getToken()->getUser();

	$app['db']->insert('conversation', array('id_user' => $user->getID(), 'id_user_to' => $request->get('id_user_to')));
	$id_conversation = $app['db']->lastInsertId();

	$app['db']->insert('notification', array('id_user' => $user->getID(), 'id_user_to' => $request->get('id_user_to'), 'text' => $request->get('mensaje'), 'id_conversation' => $id_conversation));

	return new Response();
})
->bind('crearConversacion')
;
$app->post('/crearMensaje', function(Request $request) use($app){
	return new Response();
})
->bind('crearMensaje')
;
$app->get('/getuser', function () use ($app){
	$token = $app['security']->getToken();
	return new Response(var_dump($token->getUser()));
})
->bind('getuser')
;