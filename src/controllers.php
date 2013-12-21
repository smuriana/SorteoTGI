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
			'debug' => true,
		'name' => null,
		'ruffles' => $allRuffles
		));
	}

	return $app['twig']->render('index.twig.html', array(
		'debug' => true,
		'name' => $user->getName(),
		'ruffles' => $allRuffles
		));
})
->bind('index')
;

$app->get('/descripcion/{id}/{title}', function($id, $title) use ($app){

	$user = $app['security']->getToken()->getUser();
	
    $myRuffle = new Ruffle($id,$app['db']);//Esto no creemos que este demasiado bien
	if(!is_object($user)){
		return $app['twig']->render('descripcionSorteo.twig.html', array(
		'name' => null,
		'ruffle' => $myRuffle
		));
	}

	return $app['twig']->render('descripcionSorteo.twig.html', array(
		'name' => $user->getName(),
		'ruffle' => $myRuffle
		));
})
->bind('descripcion')
;

$app->post('/buyTicket', function(Request $request) use($app){

	$user = $app['security']->getToken()->getUser();
	$app['db']->insert('ballot', array('id_user' => $user->getID(), 'id_ruffle' => $request->get('RuffleID'), 'number' => $request->get('number')));
	return $app->redirect('index');
})
->bind('buyTicket');

$app->get('/login', function (Request $request) use ($app) {

	$user = $app['security']->getToken()->getUser();

	if(!is_object($user)){
		return $app['twig']->render('login.twig.html', array(
			'invalidEmail' => false,
			'error' => $app['security.last_error']($request),
			'last_username' => $app['session']->get('_security.last_username'),
			'name' => null
    		));
	}
    
    return $app['twig']->render('login.twig.html', array(
    	'invalidEmail' => false,
    	'error' => $app['security.last_error']($request),
    	'last_username' => $app['session']->get('_security.last_username'),
    	'name' => $user->getName()
    	));
})
->bind('login')
;

$app->get('/perfil', function(Request $request) use($app){

	
	$user = $app['security']->getToken()->getUser();
    
    return $app['twig']->render('profile.twig.html', array(
    	'name' => $user->getName(),
    	'email'=> $user->getUsername()
    	));

})
->bind('perfil')
;

$app->get('/hola', function(Request $request) use ($app){
	return new Response("hola :)");
})
->bind('hola')
;

$app->post('/register', function(Request $request) use ($app){

	$sql = "SELECT * FROM user WHERE email = ?";
    $res = $app['db']->fetchAll($sql, array($request->get('email')));
    if(count($res) === 1){
    	return $app['twig']->render('login.twig.html', array('invalidEmail' => true));
    }


	$encoder = new MessageDigestPasswordEncoder();
	$encodePass = $encoder->encodePassword($request->get('password'), '');
	$app['db']->insert('user', array('username' => $request->get('email'), 'password' => $encodePass, 'nick' => $request->get('nick'), 'roles' => 'ROLE_USER'));

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