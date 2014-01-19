<?php

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

$app->get('/index', function() use ($app){

	$user = $app['security']->getToken()->getUser();
	// Devuelve todos los sorteos comenzados y los guarda en un array los sortos inicializados
	$hoy = date("Y-m-d H:i:s");
	$sql = "SELECT id FROM ruffle WHERE final_date > '".$hoy."' AND init_date < '".$hoy."'";
    $ruffles = $app['db']->fetchAll($sql);
    
    $allRuffles= array();
    foreach ($ruffles as $sorteo) {
    	$allRuffles[]=new Ruffle($sorteo['id'], $app['db']);
    }
    // <----------------------------------->
    //return new Response();

    //$myRuffle = new Ruffle($ruffles[0]["id"], $ruffles[0]["create_date"], $ruffles[0]["user_id"], $ruffles[0]["short_description"], $ruffles[0]["description"], $ruffles[0]["status"],$ruffles[0]["bill"], $ruffles[0]["guarantee"], $ruffles[0]["init_date"], $ruffles[0]["final_date"], $ruffles[0]["ballots"], $ruffles[0]["price"], $ruffles[0]["picture1"], $ruffles[0]["picture2"], $ruffles[0]["picture3"], $ruffles[0]["tags"],$ruffles[0]["sold_ballots"],$ruffles[0]["title"]);
	$myRuffle = new Ruffle(1, $app['db']);
    
	if(!is_object($user)){
		return $app['twig']->render('index.twig.html', array(
		'notifications' => null,
		'debug' => true,
		'name' => null,
		'ruffles' => $allRuffles,
		'menu_selected' => 'index'
		));
	}

	$sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);
	
	return $app['twig']->render('index.twig.html', array(
		'notifications' => $notifications,
		'user' => $user,
		'ruffles' => $allRuffles,
		'menu_selected' => 'index'
		));
})
->bind('index')
;

$app->get('/descripcion/{id}/{title}', function($id, $title) use ($app){

	$user = $app['security']->getToken()->getUser();
	
    $myRuffle = new Ruffle($id,$app['db']);//Esto no creemos que este demasiado bien


	if(!is_object($user)){
		return $app['twig']->render('descripcionSorteo.twig.html', array(
		'notifications' => null,
		'name' => null,
		'ruffle' => $myRuffle,
		'menu_selected' => 'null'
		));
	}

	$app['db']->update('notification',array(	
			'visible' => false
		),
		array(
			'id_user'	=> $user->getId(),
			'url'	 	=> '/descripcion/'.$id.'/'.$title
		));

	$sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);

	return $app['twig']->render('descripcionSorteo.twig.html', array(
		'notifications' => $notifications,
		'user' => $user,
		'ruffle' => $myRuffle,
		'menu_selected' => 'null'
		));
})
->bind('descripcion')
;

$app->get('/admin/descripcion/{id}/{title}', function($id, $title) use($app){

	$user = $app['security']->getToken()->getUser();
	
    $myRuffle = new Ruffle($id,$app['db']);//Esto no creemos que este demasiado bien

	$sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);

	return $app['twig']->render('descripcionAdminSorteo.twig.html', array(
		'notifications' => $notifications,
		'user' => $user,
		'ruffle' => $myRuffle,
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

	$sqlNotifications = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sqlNotifications);
    
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

    $sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);


	if(!is_object($user)){
		return $app['twig']->render('sorteoNuevo.twig.html', array(
		'notifications' => null,
		'name' => null,
		'menu_selected' => 'nuevoSorteo'
		));
	}

	return $app['twig']->render('sorteoNuevo.twig.html', array(
		'notifications' => $notifications,
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
	$sql = "SELECT id FROM ruffle WHERE final_date < '".$hoy."'";
    $ruffles = $app['db']->fetchAll($sql);
    
    $allRuffles= array();
    foreach ($ruffles as $sorteo) {
    	$allRuffles[]=new Ruffle($sorteo['id'], $app['db']);
    }
    $myRuffle = new Ruffle(1, $app['db']);
    
	if(!is_object($user)){
		return $app['twig']->render('index.twig.html', array(
		'notifications' => null,
		'debug' => true,
		'name' => null,
		'ruffles' => $allRuffles,
		'menu_selected' => 'sorteosTerminados'
		));
	}

	$sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);
	
	return $app['twig']->render('index.twig.html', array(
		'notifications' => $notifications,
		'user' => $user,
		'ruffles' => $allRuffles,
		'menu_selected' => 'sorteosTerminados'
		));
})
->bind('sorteosTerminados')
;

$app->get('/perfil', function(Request $request) use($app){

	
	$user = $app['security']->getToken()->getUser();

	$sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);
    
    return $app['twig']->render('profile.twig.html', array(
    	'notifications' => $notifications,
    	'user' => $user,
    	'email'=> $user->getUsername(),
    	'menu_selected' => 'perfil'
    	));

})
->bind('perfil')
;

$app->get('/perfil/{nick}', function($nick) use($app){

	$user = $app['security']->getToken()->getUser();

	$sql = "SELECT * FROM notification WHERE id_user = ".$user->getId()." AND visible = true ORDER BY time DESC";
    $notifications = $app['db']->fetchAll($sql);

    $id = $app['db']->fetchAssoc('SELECT id from user WHERE nick = ?', array($nick));
    
    $ruffles = $app['db']->fetchAll('SELECT ruffle.title, ruffle.ballots, ruffle.sold_ballots, ruffle.short_description, ruffle.final_date, ruffle.picture1, ruffle.id FROM ruffle, user WHERE ruffle.user_id = user.id AND user.nick = ?', array($nick));

    $usuario = $app['db']->fetchAssoc('SELECT user.nick, user.picture, user.rango FROM user WHERE user.nick = ?', array($nick));

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
    	'user' => $user,
    	'email'=> $user->getUsername(),
    	'menu_selected' => 'perfil',

    	'fichas' => $ruffles,
    	'user' => $usuario,
    	'valoracionMedia' => $valoracionMedia,
    	'totalValoraciones' => $totalValoraciones,
    	'totalValoraciones5' => $totalValoraciones5,
    	'totalValoraciones5' => $totalValoraciones4,
    	'totalValoraciones5' => $totalValoraciones3,
    	'totalValoraciones5' => $totalValoraciones2,
    	'totalValoraciones5' => $totalValoraciones1,
    	'opiniones' => $opiniones,

    	));

})
->bind('perfilPublico')
;

$app->post('/register', function(Request $request) use ($app){

	$sql = "SELECT * FROM user WHERE email = ?";
    $res = $app['db']->fetchAll($sql, array($request->get('email')));
    if(count($res) === 1){
    	return $app['twig']->render('login.twig.html', array('invalidEmail' => true));
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

$app->get('/getuser', function () use ($app){
	$token = $app['security']->getToken();
	return new Response(var_dump($token->getUser()));
})
->bind('getuser')
;