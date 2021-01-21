<?php
    //local devlopment

    // $servername = "localhost";
    // $username = "root";
    // $password = "";
    // $database = "rdb";
    //remote databse connectionn
    $servername = "remotemysql.com";
    $username = "gaMS65ybZ0";
    $password = "KaU41VutZi";
    $database = "gaMS65ybZ0";
    
    $conn = new mysqli($servername, $username, $password, $database);
    if($conn -> connect_error){
        die("Connection failed: " . $conn -> connect_error);
    }
?>