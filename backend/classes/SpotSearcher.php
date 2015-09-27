<?php
namespace spotyfest\classes;

require_once 'User.php';
require_once 'SpotOwner.php';

class SpotSearcher extends User
{
    public function addRequest(array $data)
    {
        if (empty($data['places'])) {
            throw new \InvalidArgumentException('Enter needed places');
        }
        
        $this->createRequest();
        
        $this->updatePlaces($data['places']);
        
        return [ 'ok' => 1 ];
    }
    
    private function updatePlaces($num)
    {
        $stmt = $this->db->prepare('UPDATE requests SET need_places = :places '
                . 'WHERE iduser = :id AND !iduser_offer');
        $res = $stmt->execute([ ':id' => $this->id, ':places' => $num ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
    }
    
    public function deleteRequest(array $data)
    {
        $this->updatePlaces(0);
        
        return [ 'ok' => 1 ];
    }
    
    public function approveOffer(array $data)
    {
        if (empty($data['offer'])) {
            throw new \InvalidArgumentException('Enter offer');
        }
        
        $needPlaces = $this->getPlaces($data['offer']);
        $owner = new SpotOwner($data['offer']);
        $freePlaces = $owner->getPlaces($data['offer']);
        
        if ($freePlaces < $needPlaces) {
            throw new \LogicException('Need more free places');
        }
        
        $stmt = $this->db->prepare('UPDATE requests SET approved = 1 '
                . 'WHERE iduser = :id AND iduser_offer = :offer');
        $res = $stmt->execute([ ':id' => $this->id, ':offer' => $data['offer'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        // send push to iduser_offer
        
        return [ 'ok' => 1 ];
    }
    
    private function createRequest()
    {
        $stmt = $this->db->prepare('INSERT IGNORE INTO requests (iduser) VALUES (:id)');
        $res = $stmt->execute([ ':id' => $this->id ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
    }
    
    public function getPlaces($offer)
    {
        $stmt = $this->db->prepare('SELECT * FROM requests '
                . 'WHERE iduser = :id AND iduser_offer = :offer');
        $stmt->execute([ ':id' => $this->id, ':offer' => $offer ]);
        $data = $stmt->fetch();
        
        return $data['need_places'];
    }
    
    public function getOffers()
    {
        $stmt = $this->db->prepare('SELECT * FROM requests '
                . 'WHERE iduser = :id AND !iduser_offer');
        $stmt->execute([ ':id' => $this->id ]);
        $data = $stmt->fetch();
        
        $needPlaces = $data['need_places'];
        if (empty($needPlaces)) {
            throw new \LogicException('Create a request first');
        }
        
        $stmt = $this->db->prepare('SELECT * FROM offers o, users u '
                . 'WHERE o.iduser = u.iduser '
                . 'AND !o.iduser_request '
                . 'AND o.free_places >= :places');
        $stmt->execute([ ':places' => $needPlaces ]);
        $list = $stmt->fetchAll();
        
        return $list;
    }
    
    public function selectOffer(array $data)
    {
        if (empty($data['offer'])) {
            throw new \InvalidArgumentException('Enter offer');
        }
        
        $stmt = $this->db->prepare('UPDATE offers SET iduser_request = :id '
                . 'WHERE iduser = :offer');
        $res = $stmt->execute([ ':id' => $this->id, ':offer' => $data['offer'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
    public function unselectOffer(array $data)
    {
        if (empty($data['offer'])) {
            throw new \InvalidArgumentException('Enter offer');
        }
        
        $stmt = $this->db->prepare('UPDATE offers SET iduser_request = null '
                . 'WHERE iduser = :offer AND iduser_request = :id AND !approved');
        $res = $stmt->execute([ ':id' => $this->id, ':offer' => $data['offer'] ]);
        if (!$res) {
            var_dump($stmt->errorInfo());
        }
        
        return [ 'ok' => 1 ];
    }
    
}
