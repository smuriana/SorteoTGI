<?php

/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace App\Ruffle;

/**
 * User is the user implementation used by the in-memory user provider.
 *
 * This should not be used for anything else.
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
final class Ruffle 
{
    private $id;
    private $create_date;
    private $user_id;
    private $short_description;
    private $description;
    private $status;
    private $bill;
    private $guarantee;
    private $init_date;
    private $final_date;
    private $ballots;
    private $price;
    private $picture1;
    private $picture2;
    private $picture3; 
    private $tags;
    private $sold_ballots;
    private $title;
    private $conexion;

    public function __construct($id, $conexion)
    {

        $sql = "SELECT * FROM ruffle WHERE id = ".$id;//PELIGRO de seguridad!!! 
    
        $ruffles = $conexion->fetchAll($sql);


        $this->id = $ruffles[0]["id"];
        $this->create_date = $ruffles[0]["create_date"];
        $this->user_id = $ruffles[0]["user_id"];
        $this->description = $ruffles[0]["description"];
        $this->short_description = $ruffles[0]["short_description"];
        $this->status = $ruffles[0]["status"];
        $this->bill = $ruffles[0]["bill"];
        $this->guarantee = $ruffles[0]["guarantee"];
        $this->init_date = $ruffles[0]["init_date"];
        $this->final_date = $ruffles[0]["final_date"]; 
        $this->ballots = $ruffles[0]["ballots"];
        $this->price = $ruffles[0]["price"];
        $this->picture1 = $ruffles[0]["picture1"];
        $this->picture2 = $ruffles[0]["picture2"];
        $this->picture3 = $ruffles[0]["picture3"];
        $this->tags = $ruffles[0]["tags"];
        $this->sold_ballots = $ruffles[0]["sold_ballots"];
        $this->title = $ruffles[0]["title"];
        $this->conexion=$conexion;
    }

    /**
     * {@inheritdoc}
     */
    public function getId()
    {
        return $this->id;
    }

    /**
     * {@inheritdoc}
     */
    public function getCreateDate()
    {
        return $this->create_date;
    }

    /**
     * {@inheritdoc}
     */
    public function getUserId()
    {
        return user_id;
    }

    /**
     * {@inheritdoc}
     */
    public function getShortDescription()
    {
        
        return $this->short_description;

    }

    /**
     * {@inheritdoc}
     */
    public function getDescription()
    {
        return $this->description;
    }

    /**
     * {@inheritdoc}
     */
    public function getStatus()
    {
        return $this->status;
    }

    /**
     * {@inheritdoc}
     */
    public function haveBill()
    {
        return $this->bill;
    }

    /**
     * {@inheritdoc}
     */
    public function haveGuarantee()
    {
        return $this->accountNonExpired;
    }

    /**
     * {@inheritdoc}
     */
    public function getInitDate()
    {
        return $this->init_date;
    }

    /**
     * {@inheritdoc}
     */
    public function getFinalDate()
    {
        return $this->final_date;
    }

    /**
     * {@inheritdoc}
     */
    public function getBallots()
    {
        return $this->ballots;
    }

    /**
     * {@inheritdoc}
     */
    public function getPrice()
    {
        return $this->price;
    }

    /**
     * {@inheritdoc}
     */
    public function getPicture1()
    {
        return $this->picture1;
    }

    /**
     * {@inheritdoc}
     */
    public function getPicture2()
    {
        return $this->picture2;
    }

    /**
     * {@inheritdoc}
     */
    public function getPicture3()
    {
        return $this->picture3;
    }

    /**
     * {@inheritdoc}
     */
    public function getTags()
    {
        return $this->tags;
    }

    /**
     * {@inheritdoc}
     */
    public function getSoldBallots()
    {
        return $this->sold_ballots;
    }

    /**
     * {@inheritdoc}
     */
    public function getTitle()
    {
        return $this->title;
    }

    /**
     * {@inheritdoc}
     */
    public function getArrayBallots()
    {
        $sql = "SELECT number FROM ballot WHERE id_ruffle = ".$this->id;//PELIGRO de seguridad!!! 
    
        $array = $this->conexion->fetchAll($sql);
        $numeros = array();
        foreach ($array as $arr)
        {
            $numeros[]=$arr['number'];
           
        }

        return $numeros;
    }
}
