<?php

/* layout_.twig.html */
class __TwigTemplate_9b1cb83f02bb80cbaf910d28095068e09e1e5842f315adb79a3856bf2911bae2 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = false;

        $this->blocks = array(
            'title' => array($this, 'block_title'),
            'content' => array($this, 'block_content'),
        );
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        // line 1
        echo "<!DOCTYPE html>
<html>
  <head>
    <title>";
        // line 4
        $this->displayBlock('title', $context, $blocks);
        echo " - Sorteos</title>

    <link href=\"";
        // line 6
        echo twig_escape_filter($this->env, $this->getAttribute($this->getAttribute($this->getContext($context, "app"), "request"), "basepath"), "html", null, true);
        echo "/css/main.css\" rel=\"stylesheet\" type=\"text/css\" />
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <!-- Bootstrap -->
    <link href=\"";
        // line 9
        echo twig_escape_filter($this->env, $this->getAttribute($this->getAttribute($this->getContext($context, "app"), "request"), "basepath"), "html", null, true);
        echo "/bootstrap/css/bootstrap.min.css\" rel=\"stylesheet\">
    <style>
      header {margin-bottom: 100px;}
      .table > tbody > tr > td{padding:4px;}
      .carousel-inner { text-align: center;}
      .carousel .item > img { display: inline-block; height: 400px;max-height: 400px;}
      .pull-right { margin-right: 2px;}
      .label {}
      .tabla.btn{padding:1px 4px;}
    </style>
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src=\"https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js\"></script>
      <script src=\"https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js\"></script>
    <![endif]-->
  </head>
  <body>
    <header class=\"navbar navbar-inverse navbar-fixed-top bs-docs-nav\" role=\"banner\">
      <div class=\"container\">
        <div class=\"navbar-header\">
          <button class=\"navbar-toggle\" type=\"button\" data-toggle=\"collapse\" data-target=\".bs-navbar-collapse\">
            <span class=\"sr-only\">Toggle navigation</span>
            <span class=\"icon-bar\"></span>
            <span class=\"icon-bar\"></span>
            <span class=\"icon-bar\"></span>
          </button>
          <a href=\"../\" class=\"navbar-brand\">Sortilandia</a>
        </div>
        <nav class=\"collapse navbar-collapse bs-navbar-collapse\" role=\"navigation\">
          <ul class=\"nav navbar-nav\">
            <li class=\"active\">
              <a href=\"../getting-started\">Sorteos disponibles</a>
            </li>
            <li>
              <a href=\"../css\">Sorteos Terminados</a>
            </li>
          </ul>
          <ul class=\"nav navbar-nav navbar-right\">
            ";
        // line 48
        if ($this->env->getExtension('security')->isGranted("IS_AUTHENTICATED_FULLY")) {
            // line 49
            echo "              <li>
                <a href=\"../components\"></a>
              </li>
              <li>
                <a style=\"padding:4px 0px\" href=\"../components\"><img class=\"img-circle\" src=\"";
            // line 53
            echo twig_escape_filter($this->env, $this->getAttribute($this->getAttribute($this->getContext($context, "app"), "request"), "basepath"), "html", null, true);
            echo "/img/Alien1.bmp\" alt=\"Imagen de perfil\" style=\"width: 3em; height: 3em; border:2px solid gray;\"><span style=\"padding:11px\">";
            if ($this->env->getExtension('security')->isGranted("IS_AUTHENTICATED_FULLY")) {
                echo "  Perfil de ";
                echo twig_escape_filter($this->env, $this->getContext($context, "name"), "html", null, true);
                echo " ";
            } else {
                echo " Perfil ";
            }
            echo "</span></a>
              </li>
              <li>
                <a href=\"location.href='";
            // line 56
            echo $this->env->getExtension('routing')->getPath("logout");
            echo "'\"><span class=\"glyphicon glyphicon-log-out\"></span> Cerrar sesi&oacute;n</a>
              </li>
            ";
        } else {
            // line 59
            echo "              <li class=\"dropdown\">
                <a class=\"dropdown-toggle\" href=\"#\" data-toggle=\"dropdown\">Entrar <strong class=\"caret\"></strong></a>
                <div class=\"dropdown-menu\" style=\"padding: 15px; padding-bottom: 0px;\">
                  <!-- Login form here -->
                  <form class=\"form-horizontal\" role=\"form\" action=\"";
            // line 63
            echo $this->env->getExtension('routing')->getPath("login_check");
            echo "\" method=\"post\">
                    <div class=\"row\">
                      <div class=\"form-group\">
                        <div class=\"col-sm-10 col-sm-offset-1\">
                          <input type=\"email\" class=\"form-control\" id=\"inputEmail\" placeholder=\"Email\" name=\"email\" required>
                        </div>
                      </div>
                    </div>
                    <div class=\"row\">
                      <div class=\"form-group\">
                        <div class=\"col-sm-10 col-sm-offset-1\">
                          <input type=\"password\" class=\"form-control\" id=\"inputPassword\" placeholder=\"Contraseña\" name=\"password\" required>
                        </div>
                      </div>
                    </div>
                    <div class=\"row\">
                      <div class=\"form-group\"> 
                        <div class=\"col-sm-10 col-sm-offset-1\">
                          <input type=\"checkbox\" name=\"remember_me\"> Recuerdame
                        </div>
                      </div>
                    </div>
                    <div class=\"row\">
                        <div class=\"form-group\">
                          <div class=\"col-sm-10 col-sm-offset-1\">
                            <button  class=\"btn btn-primary btn-block\">Entrar</button>
                          </div>
                        </div>
                    </div>
                  </form>
                </div>
              </li>
            ";
        }
        // line 96
        echo "          </ul>
      </div>
    </header>


    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src=\"https://code.jquery.com/jquery.js\"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src=\"";
        // line 104
        echo twig_escape_filter($this->env, $this->getAttribute($this->getAttribute($this->getContext($context, "app"), "request"), "basepath"), "html", null, true);
        echo "/bootstrap/js/bootstrap.min.js\"></script>
    ";
        // line 105
        $this->displayBlock('content', $context, $blocks);
        // line 106
        echo "
  </body>
</html>
";
    }

    // line 4
    public function block_title($context, array $blocks = array())
    {
        echo "";
    }

    // line 105
    public function block_content($context, array $blocks = array())
    {
    }

    public function getTemplateName()
    {
        return "layout_.twig.html";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  178 => 105,  172 => 4,  165 => 106,  163 => 105,  159 => 104,  149 => 96,  113 => 63,  107 => 59,  101 => 56,  87 => 53,  81 => 49,  79 => 48,  37 => 9,  31 => 6,  26 => 4,  21 => 1,);
    }
}
