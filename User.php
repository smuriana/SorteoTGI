<?php

/*
 * This file is part of the Symfony package.
 *
 * (c) Fabien Potencier <fabien@symfony.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Symfony\Component\Security\Core\User;

/**
 * User is the user implementation used by the in-memory user provider.
 *
 * This should not be used for anything else.
 *
 * @author Fabien Potencier <fabien@symfony.com>
 */
final class User implements AdvancedUserInterface
{
    private $email;
    private $nick;
    private $password;
    private $enabled;
    private $accountNonExpired;
    private $credentialsNonExpired;
    private $accountNonLocked;
    private $roles;
    private $sexo;
    private $rango;
    private $nombre;
    private $apellidos;
    private $direccion;
    private $cp;
    private $provincia; 
    private $localidad;
    private $id;
    private $picture;

    public function __construct($email, $nick, $password, array $roles = array(), $enabled = true, $userNonExpired = true, $credentialsNonExpired = true, $userNonLocked = true, $sexo, $rango, $nombre, $apellidos, $direccion, $cp, $provincia, $localidad, $id, $picture)
    {
        if (empty($email)) {
            throw new \InvalidArgumentException('The email cannot be empty.');
        }

        $this->email = $email;
        $this->nick = $nick;
        $this->password = $password;
        $this->enabled = $enabled;
        $this->accountNonExpired = $userNonExpired;
        $this->credentialsNonExpired = $credentialsNonExpired;
        $this->accountNonLocked = $userNonLocked;
        $this->roles = $roles;
        $this->sexo = $sexo;
        $this->rango = $rango; 
        $this->nombre = $nombre;
        $this->apellidos = $apellidos;
        $this->direccion = $direccion;
        $this->cp = $cp;
        $this->provincia = $provincia;
        $this->localidad = $localidad;
        $this->id = $id;
        $this->picture = $picture;
    }

    /**
     * {@inheritdoc}
     */
    public function getID()
    {
        return $this->id;
    }

    /**
     * {@inheritdoc}
     */
    public function getNick()
    {
        return $this->nick;
    }

    /**
     * {@inheritdoc}
     */
    public function getPicture()
    {
        return $this->picture;
    }

    /**
     * {@inheritdoc}
     */
    public function getRoles()
    {
        return $this->roles;
    }

    /**
     * {@inheritdoc}
     */
    public function getPassword()
    {
        return $this->password;
    }

    /**
     * {@inheritdoc}
     */
    public function getSalt()
    {
        return null;
    }

    /**
     * {@inheritdoc}
     */
    public function getUsername()
    {
        return $this->email;
    }

    /**
     * {@inheritdoc}
     */
    public function getSexo()
    {
        return $this->sexo;
    }

    /**
     * {@inheritdoc}
     */
    public function getName()
    {
        return $this->nombre;
    }

    /**
     * {@inheritdoc}
     */
    public function isAccountNonExpired()
    {
        return $this->accountNonExpired;
    }

    /**
     * {@inheritdoc}
     */
    public function isAccountNonLocked()
    {
        return $this->accountNonLocked;
    }

    /**
     * {@inheritdoc}
     */
    public function isCredentialsNonExpired()
    {
        return $this->credentialsNonExpired;
    }

    /**
     * {@inheritdoc}
     */
    public function isEnabled()
    {
        return $this->enabled;
    }

    /**
     * {@inheritdoc}
     */
    public function eraseCredentials()
    {
    }
}
