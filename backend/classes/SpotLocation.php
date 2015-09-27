<?php
namespace spotyfest\classes;

class SpotLocation
{
    public $zelt;
    public $box;
    public $reihe;
    public $tisch;
    
    public function __construct(array $data)
    {
        $this->zelt = $data['zelt'];
        $this->box = $data['box'];
        $this->reihe = $data['reihe'];
        $this->tisch = $data['tisch'];
    }
    
    public function toString()
    {
        $res = [];
        $res[] = 'Zelt: ' . $this->zelt;
        $res[] = 'Box: ' . $this->box;
        $res[] = 'Reihe: ' . $this->reihe;
        $res[] = 'Tisch: ' . $this->tisch;
        
        $res = join(', ', $res);
        
        return $res;
    }
    
}
