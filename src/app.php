<?php

use Silex\Application;
use Silex\Provider\TwigServiceProvider;
use Silex\Provider\UrlGeneratorServiceProvider;
use Silex\Provider\ValidatorServiceProvider;
use Silex\Provider\ServiceControllerServiceProvider;

$app = new Application();
$app->register(new UrlGeneratorServiceProvider());
$app->register(new ValidatorServiceProvider());
$app->register(new ServiceControllerServiceProvider());
$app->register(new Silex\Provider\SecurityServiceProvider());
$app->register(new Silex\Provider\SessionServiceProvider());
$app->register(new Silex\Provider\RememberMeServiceProvider());
$app->register(new TwigServiceProvider(), array(
    'twig.path'    => array(__DIR__.'/../templates'),
    'twig.options' => array('cache' => __DIR__.'/../cache/twig'),
));
$app['twig'] = $app->share($app->extend('twig', function($twig, $app) {
    // add custom globals, filters, tags, ...

    return $twig;
}));

$app->register(new Silex\Provider\DoctrineServiceProvider(), array(
	'db.options' 	=> array(
	'driver' 		=> 'pdo_mysql',
	'host'			=> 'localhost',
	'dbname'		=> 'sorteos_db',
	'user'			=> 'admin',
	'password'		=> 'admin',
	'charset'		=> 'utf8',
	'driverOptions'	=>  array(1002 => 'SET NAMES utf8',),
	),
	));
$app['debug'] = false;
$app['security.firewalls'] = array(

    'secured' => array(
        'pattern' => '^.*$',
        'form'      => array(
            'login_path'         => '/login',
            'check_path'        => '/login_check',
            'username_parameter' => 'email',
            'password_parameter' => 'password',
            'default_target_path' => '/'
        ),
        'logout' => array(
        	'logout_path' => '/logout',
        	'target' => '/'
       	),
       	'remember_me' => array(
       		'key'						=> 'Un secreto vale lo que aquellos de quienes tenemos que guardarlo.',
       		'lifetime'					=> '3600',
       		'remember_me_parameter' 	=> 'remember_me'
       	),
        'anonymous' => true,
        'users' => $app->share(function () use ($app) {
		return new App\User\UserProvider($app['db']);
        }),
    ),
);

$app['security.access_rules'] = array(
	array('^/$', 'IS_AUTHENTICATED_ANONYMOUSLY'),
	array('^/index', 'IS_AUTHENTICATED_ANONYMOUSLY'),
	array('^/register', 'IS_AUTHENTICATED_ANONYMOUSLY'),
	array('^/login$', 'IS_AUTHENTICATED_ANONYMOUSLY'),
    array('^/admin', 'ROLE_ADMIN'),
    array('^.*$', 'ROLE_USER'),
);
return $app;
