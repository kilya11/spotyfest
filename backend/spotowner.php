<?php
namespace spotyfest;

require_once 'classes/SpotOwner.php';

use spotyfest\classes\SpotOwner;

$ret = [];

do {
    if (empty($_REQUEST['action'])) {
        $ret['error'] = 'No action';
        break;
    }
    
    if (empty($_REQUEST['data'])) {
        $ret['error'] = 'No data';
        break;
    }

    $action = $_REQUEST['action'];
    $data = $_REQUEST['data'];
    
    try {
        $user = new SpotOwner($data['id']);
        $ret = $user->$action($data);
    } catch (Exception $ex) {
        $ret['error'] = $ex->getMessage();
        break;
    }
} while(false);

echo json_encode($ret);
