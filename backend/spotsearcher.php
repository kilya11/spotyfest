<?php
namespace spotyfest;

require_once 'classes/SpotSearcher.php';

use spotyfest\classes\SpotSearcher;

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
        $user = new SpotSearcher($data['id']);
        $ret = $user->$action($data);
    } catch (Exception $ex) {
        $ret['error'] = $ex->getMessage();
        break;
    }
} while(false);

echo json_encode($ret);
