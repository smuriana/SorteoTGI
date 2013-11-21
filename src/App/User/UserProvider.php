<?php
// app/src/App/User/UserProvider.php
namespace App\User;
 
use Symfony\Component\Security\Core\User\UserProviderInterface;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Core\User\User;
use Symfony\Component\Security\Core\Exception\UsernameNotFoundException;
use Symfony\Component\Security\Core\Exception\UnsupportedUserException;
use Doctrine\DBAL\Connection;
 
class UserProvider implements UserProviderInterface
{
    private $conn;
 
    public function __construct(Connection $conn)
    {
        $this->conn = $conn;
    }
 
    public function loadUserByUsername($email)
    {
        $stmt = $this->conn->executeQuery('SELECT * FROM user WHERE email = ?', array(strtolower($email)));
        if (!$user = $stmt->fetch()) {
            throw new UsernameNotFoundException(sprintf('Username "%s" does not exist.', $email));
        }
 
        return new User($user['email'], $user['password'], explode(',', $user['roles']), true, true, true, true, $user['sexo'], $user['rango'], $user['nombre'], $user['apellidos'], $user['direccion'], $user['cp'], $user['provincia'], $user['localidad'], $user['id']);
    }
 
    public function refreshUser(UserInterface $user)
    {
        if (!$user instanceof User) {
            throw new UnsupportedUserException(sprintf('Instances of "%s" are not supported.', get_class($user)));
        }
 
        return $this->loadUserByUsername($user->getUsername());
    }
 
    public function supportsClass($class)
    {
        return $class === 'Symfony\Component\Security\Core\User\User';
    }
}