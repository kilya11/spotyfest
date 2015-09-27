<?php
namespace spotyfest\classes;

require_once 'User.php';
require_once 'SpotLocation.php';

class SpotOwner extends User
{
    public $spot;
    
    public function approveRequest(array $data)
    {
        if (empty($data['request'])) {
            throw new \InvalidArgumentException('Enter request');
        }
        
        $freePlaces = $this->getPlaces($data['request']);
        $searcher = new SpotSearcher($data['request']);
        $needPlaces = $searcher->getPlaces();
        
        if ($freePlaces < $needPlaces) {
            throw new \LogicException('Need more free places');
        }
        
        $stmt = $this->db->prepare('UPDATE offers SET approved = 1 '
                . 'WHERE iduser = :id AND iduser_request = :request');
        $res = $stmt->execute([ ':id' => $this->id, ':request' => $data['request'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        $this->updatePlaces($freePlaces - $needPlaces);
        
        // send push to iduser_request
        
        return [ 'ok' => 1 ];
    }
    
    public function selectRequest(array $data)
    {
        if (empty($data['request'])) {
            throw new \InvalidArgumentException('Enter request');
        }
        
        $stmt = $this->db->prepare('UPDATE requests SET iduser_offer = :id '
                . 'WHERE iduser = :request');
        $res = $stmt->execute([ ':id' => $this->id, ':request' => $data['request'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
    public function unselectRequest(array $data)
    {
        if (empty($data['request'])) {
            throw new \InvalidArgumentException('Enter request');
        }
        
        $stmt = $this->db->prepare('UPDATE requests SET iduser_offer = null '
                . 'WHERE iduser = :request AND iduser_offer = :id AND !approved');
        $res = $stmt->execute([ ':id' => $this->id, ':request' => $data['request'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
    private function getPlaces($request)
    {
        $stmt = $this->db->prepare('SELECT * FROM offers '
                . 'WHERE iduser = :id AND iduser_request = :request');
        $stmt->execute([ ':id' => $this->id, ':request' => $request ]);
        $data = $stmt->fetch();
        
        return $data['free_places'];
    }
    
    public function getRequests()
    {
        $stmt = $this->db->prepare('SELECT * FROM offers '
                . 'WHERE iduser = :id AND !iduser_request');
        $stmt->execute([ ':id' => $this->id ]);
        $data = $stmt->fetch();
        
        $freePlaces = $data['free_places'];
        if (empty($freePlaces)) {
            throw new \LogicException('Create an offer first');
        }
        
        $stmt = $this->db->prepare('SELECT * FROM requests r, users u '
                . 'WHERE r.iduser = u.iduser '
                . 'AND r.need_places <= :places AND r.need_places > 0 '
                . 'AND !r.iduser_offer');
        $stmt->execute([ ':places' => $freePlaces ]);
        
        $list = $stmt->fetchAll();
        
        return $list;
    }
    
    public function addOffer(array $data)
    {
        if (empty($data['places'])) {
            throw new \InvalidArgumentException('Enter free places');
        }
        
        $this->createOffer();
        
        $stmt = $this->db->prepare('UPDATE offers SET free_places = :places '
                . 'WHERE iduser = :id AND !iduser_request');
        $res = $stmt->execute([ ':id' => $this->id, ':places' => $data['places'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
    public function deleteOffer(array $data)
    {
        $this->updatePlaces(0);
        
        return [ 'ok' => 1 ];
    }
    
    private function createOffer()
    {
        $stmt = $this->db->prepare('INSERT IGNORE INTO offers (iduser) VALUES (:id)');
        $res = $stmt->execute([ ':id' => $this->id ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
    }
    
    private function updatePlaces($num)
    {
        $stmt = $this->db->prepare('UPDATE offers SET free_places = :places '
                . 'WHERE iduser = :id AND !iduser_request');
        $res = $stmt->execute([ ':id' => $this->id, ':places' => $num ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
    }
    
    public function saveSpot(array $data)
    {
        if (empty($data['spot'])) {
            throw new \InvalidArgumentException('Enter spot data');
        }
        
        $spot = new SpotLocation($data['spot']);
        $stmt = $this->db->prepare('UPDATE users '
                . 'SET spot = :spot '
                . 'WHERE iduser = :id');
        $res = $stmt->execute([ ':id' => $this->id, ':spot' => $spot->toString() ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
    public function load(array $data)
    {
        parent::load($data);
        
        $stmt = $this->db->prepare('SELECT * FROM users WHERE iduser = :id');
        $stmt->execute([ ':id' => $this->id ]);
        $info = $stmt->fetch();
        
        $this->spot = $info['spot'];
        
        return $this->toArray();
    }
    
    private function toArray()
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'foto' => $this->foto,
            'spot' => $this->spot,
        ];
    }
}
