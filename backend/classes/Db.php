<?php
namespace spotyfest\classes;

class Db
{
    private $pdo;
    static private $instance;
    
    private function __construct()
    {
        if (isset($_SERVER['SERVER_SOFTWARE']) 
            && strpos($_SERVER['SERVER_SOFTWARE'], 'Google App Engine') !== false
        ) {
            $mysqlServer = 'unix_socket=/cloudsql/spotyfest:maindb';
            $this->pdo = new \PDO('mysql:' . $mysqlServer . ';dbname=main_db',
                'root',  // username
                ''    // password
            );
        } else {
            $mysqlServer = '173.194.238.255:3306';
            $this->pdo = new \PDO('mysql:' . $mysqlServer . ';dbname=main_db',
                'script',  // username
                ''    // password
            );
        }
        
        $this->pdo->query('USE main_db');
        $this->pdo->setAttribute(\PDO::ATTR_DEFAULT_FETCH_MODE, \PDO::FETCH_ASSOC);
    }
    
    static public function get()
    {
        if (!self::$instance) {
            self::$instance = new self();
        }
        
        return self::$instance;
    }
 
    public function prepare($sql)
    {
        return $this->pdo->prepare($sql);
    }
}
