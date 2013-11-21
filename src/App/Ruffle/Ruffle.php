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

    public function __construct($id, $create_date, $user_id, $short_description, $description, $status, $bill, $guarantee, $init_date, $final_date, $ballots, $price, $picture1, $picture2, $picture3, $tags, $sold_ballots,$title)
    {
        
        $this->id = $id;
        $this->create_date = $create_date;
        $this->user_id = $user_id;
        $this->description = $description;
        $this->short_description = $short_description;
        $this->status = $status;
        $this->bill = $bill;
        $this->guarantee = $guarantee;
        $this->init_date = $init_date;
        $this->final_date = $final_date; 
        $this->ballots = $ballots;
        $this->price = $price;
        $this->picture1 = $picture1;
        $this->picture2 = $picture2;
        $this->picture3 = $picture3;
        $this->tags = $tags;
        $this->sold_ballots = $sold_ballots;
        $this->title = $title;
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
}
