<?php
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/json; charset=UTF-8");
    header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

    include "inspectionmodel.php";
    
    $inspection = new InspectionModel();
    $method = $_SERVER['REQUEST_METHOD'];
    $request_uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    $uri_segments = explode('/', $request_uri);

    switch($method) 
    {
        case 'GET':
            $id = end($uri_segments);
            if(is_numeric($id))
            {
                $inspection->id = $id;
                $result = $inspection->readSingle();
                $row = $result->fetch_assoc();
                echo json_encode($row);
            } else
            {
                $result = $inspection->read();
                $data = [];
                while($row = $result->fetch_assoc())
                {
                    $data[] = $row;
                }
                echo json_encode($data);
            }
            break;
        case "POST":
            $data = json_decode(file_get_contents("php://input"));
            $inspection->inspector = $data->inspector;
            $inspection->date = $data->date;
            $inspection->facility = $data->facility;
            $inspection->status = $data->status;
            $inspection->details = $data->details;
            
            if ($inspection->create()) 
            {
                http_response_code(201) || http_response_code(200);
                echo json_encode(["message" => "Inspection successfully created"]);
            } else
            {
                http_response_code(503);
                echo json_encode(["message" => "Failed to create inspection"]);
            }
            break;
        case "DELETE":
            $id = end($uri_segments);
            $inspection->id = $id;

            if ($inspection->delete())
            {
                http_response_code(200) || http_response_code(201);
                echo json_encode(["message" => "inspection successfully deleted"]);
            } else
            {
                http_response_code(503);
                echo json_encode(["message" => "Failed to delete inspection"]);
            }
            break;
    }
?>