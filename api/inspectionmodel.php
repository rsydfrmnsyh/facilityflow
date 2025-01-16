<?php
    require "connect.php";
    class InspectionModel extends Connection
    {
        private $id;
        private $inspector;
        private $date;
        private $facility;
        private $status;
        private $details;

        public function __get($atribute)
        {
            if (property_exists($this, $atribute))
            {
                return $this->$atribute;
            }
        }
        public function __set($atribut, $value)
        {
            if (property_exists($this, $atribut))
            {
                $this->$atribut = $value;
            }
        }

        public function read()
        {
            $query = "SELECT * FROM inspections";
            return $this->conn->query($query);
        }

        public function readSingle()
        {
            $query = "SELECT * FROM inspections where id =" . $this->id;
            return $this->conn->query($query);
        }

        public function create() 
        {
            $query = "INSERT INTO inspections (inspector, date, facility, status, details)
                      VALUES ('$this->inspector', '$this->date', '$this->facility','$this->status', '$this->details')";
            return $this->conn->query($query);
        }

        public function delete()
        {
            $query = "DELETE FROM inspections WHERE id = " . $this->id;
            return $this->conn->query($query);
        }
    }
?>