<?php 
    $results_per_page = 5;  
    $result = $conn->query($sql); 
    $number_of_result = $result->num_rows;
    $number_of_page = ceil ($number_of_result / $results_per_page);    
    if (!isset ($_GET['page']) ) {  
        $page = 1;  
    } else {  
        $page = $_GET['page'];  
    } 
    $page_first_result = ($page-1) * $results_per_page;  
?>