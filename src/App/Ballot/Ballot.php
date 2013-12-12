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
    private $user_id;
    private $ruffle_id;
    private $number;

    public function __construct($id, $user_id, $ruffle_id, $number)
    {
        
        $this->id = $id;
        $this->user_id = $user_id;
        $this->ruffle_id = $ruffle_id;
        $this->number = $number;
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
    public function getUserId()
    {
        return user_id;
    }

    /**
     * {@inheritdoc}
     */
    public function getRuffleId()
    {
        
        return $this->ruffle_id;

    }

    /**
     * {@inheritdoc}
     */
    public function getNumber()
    {
        return $this->number;
    }
}
