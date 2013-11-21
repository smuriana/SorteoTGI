<?php

/* index.twig.html */
class __TwigTemplate_ac6f229a053bd62cc00eec490980c0e65414bd83f77b79a098c3cfeb3f4152d8 extends Twig_Template
{
    public function __construct(Twig_Environment $env)
    {
        parent::__construct($env);

        $this->parent = $this->env->loadTemplate("layout_.twig.html");

        $this->blocks = array(
            'content' => array($this, 'block_content'),
        );
    }

    protected function doGetParent(array $context)
    {
        return "layout_.twig.html";
    }

    protected function doDisplay(array $context, array $blocks = array())
    {
        $this->parent->display($context, array_merge($this->blocks, $blocks));
    }

    // line 3
    public function block_content($context, array $blocks = array())
    {
        // line 4
        echo "<div class=\"container\">
<div class=\"col-md-12 row\" style=\"margin-top:65px;\">

  ";
        // line 7
        $context['_parent'] = (array) $context;
        $context['_seq'] = twig_ensure_traversable(range(0, 7));
        foreach ($context['_seq'] as $context["_key"] => $context["i"]) {
            // line 8
            echo "
  <div class=\"col-sm-6 col-md-3 panel\">
    <div class=\"thumbnail\">
    \t<div class=\"panel-body\">

      \t\t<img src=\"";
            // line 13
            echo twig_escape_filter($this->env, $this->getAttribute($this->getAttribute($this->getContext($context, "app"), "request"), "basepath"), "html", null, true);
            echo twig_escape_filter($this->env, $this->getAttribute($this->getContext($context, "ruffle"), "getPicture1"), "html", null, true);
            echo "\" alt=\"...\" style=\"width: 200px; height: auto; border:2px solid gray;\">
          <div class=\"progress progress-striped active\">
            
            <div class=\"progress-bar progress-bar-success\" role=\"progressbar\" style=\"width: ";
            // line 16
            if (($this->getAttribute($this->getContext($context, "ruffle"), "getBallots") < 11)) {
                echo twig_escape_filter($this->env, ($this->getAttribute($this->getContext($context, "ruffle"), "getSoldBallots") * 10), "html", null, true);
            } else {
                echo twig_escape_filter($this->env, $this->getAttribute($this->getContext($context, "ruffle"), "getSoldBallots"), "html", null, true);
            }
            echo "%\">
              <span>Quedan ";
            // line 17
            echo twig_escape_filter($this->env, ($this->getAttribute($this->getContext($context, "ruffle"), "getBallots") - $this->getAttribute($this->getContext($context, "ruffle"), "getSoldBallots")), "html", null, true);
            echo " papeletas</span>
            </div>
          </div>
 
        <h3>";
            // line 21
            echo twig_escape_filter($this->env, $this->getAttribute($this->getContext($context, "ruffle"), "getTitle"), "html", null, true);
            echo "</h3>
        <p>";
            // line 22
            echo twig_escape_filter($this->env, $this->getAttribute($this->getContext($context, "ruffle"), "getShortDescription"), "html", null, true);
            echo "</p>
        <p><a href=\"";
            // line 23
            echo $this->env->getExtension('routing')->getPath("descripcion");
            echo "\" class=\"btn btn-primary\" role=\"button\">Quiero saber más</a> </p>
        </div>  
      
        <div class=\"panel-footer\">
        <span class=\"glyphicon glyphicon-time\" style=\"margin-right:20%;\"></span>Quedan ";
            // line 27
            echo twig_escape_filter($this->env, (twig_date_format_filter($this->env, $this->getAttribute($this->getContext($context, "ruffle"), "getFinalDate"), "d") - twig_date_format_filter($this->env, "now")), "html", null, true);
            echo " dias
        
        </div>
      
    </div>
  </div>

  ";
        }
        $_parent = $context['_parent'];
        unset($context['_seq'], $context['_iterated'], $context['_key'], $context['i'], $context['_parent'], $context['loop']);
        $context = array_intersect_key($context, $_parent) + $_parent;
        // line 35
        echo "
";
    }

    public function getTemplateName()
    {
        return "index.twig.html";
    }

    public function isTraitable()
    {
        return false;
    }

    public function getDebugInfo()
    {
        return array (  98 => 35,  84 => 27,  77 => 23,  73 => 22,  69 => 21,  62 => 17,  54 => 16,  47 => 13,  40 => 8,  36 => 7,  31 => 4,  28 => 3,);
    }
}
