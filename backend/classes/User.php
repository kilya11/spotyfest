<?php
namespace spotyfest\classes;

require_once 'Db.php';

abstract class User
{
    protected $id;
    
    public $name;
    
    public $foto;
    
    /**
     * @var \PDO
     */
    protected $db;
    
    public function __construct($id)
    {
        if (empty($id)) {
            throw new \InvalidArgumentException('Enter User ID');
        }
        
        $this->id = $id;
        
        $this->db = Db::get();
    }
   
    public function save(array $data)
    {
        if (empty($data['name'])) {
            throw new \InvalidArgumentException('Enter User name');
        }
        
        if (empty($data['foto'])) {
            $data['foto'] = '';
        }
        
        $stmt = $this->db->prepare('UPDATE users '
                . 'SET name = :name, foto = :foto '
                . 'WHERE iduser = :id');
        $res = $stmt->execute([ ':id' => $this->id, ':name' => $data['name'], ':foto' => $data['foto'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
    public function load(array $data)
    {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE iduser = :id');
        $stmt->execute([ ':id' => $this->id ]);
        $info = $stmt->fetch();
        if (empty($info)) {
            $this->create();
            $this->save($data);
            $info = $stmt->execute([ ':id' => $this->id ]);
        }
        
        $this->name = $info['name'];
        
        return $this->toArray();
    }
    
    private function toArray()
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'foto' => $this->foto,
        ];
    }
    
    private function create()
    {
        $stmt = $this->db->prepare('INSERT INTO users (iduser) VALUES (:id)');
        $res = $stmt->execute([ ':id' => $this->id ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
    }
    
}
