<?php
    session_start();
    include "config/connection.php";

    // FOR PAGINATION
    $sql = "SELECT * FROM train ORDER BY t_date DESC";

    include "template/pagination.php";  
    
    $sql = "SELECT *FROM train ORDER BY t_date DESC LIMIT " . $page_first_result . ',' . $results_per_page;  
    $result = $conn->query($sql); 
    $conn->close();  
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Trains</title>
</head>

<?php 
    if(isset($_SESSION['username']))
        include "template/header-name.php";
    else
        include "template/header.php";
?>

<style> 
    table { 
        margin: 0 auto; 
        font-size: large; 
        border: 2px solid rgb(120, 120, 120); 
    }
    td { 
        background-color: #E4F5D4; 
        border: 2px solid rgb(120, 120, 120); 
    } 

    th, td { 
        font-weight: bold; 
        border: 2px dotted rgb(120, 120, 120); 
        padding: 10px; 
        text-align: center; 
    } 
    td { 
        font-weight: lighter; 
    } 
</style> 

<div style="margin-top:100px;">
<form style="width: 80%;">
    <h3 class="heading">All Released Trains</h3> <br>
    <section>
        <table> 
            <tr> 
                <th>Train Number</th> 
                <th>Date Of Departure</th> 
                <th>Number Of AC Coaches</th> 
                <th>Number Of Sleeper Coaches </th> 
            </tr> 
            <?php 
                while($rows=$result->fetch_assoc()) 
                { 
             ?> 
            <tr> 
                <td><?php echo $rows['t_number'];?></td> 
                <td><?php echo $rows['t_date'];?></td> 
                <td><?php echo $rows['num_ac'];?></td> 
                <td><?php echo $rows['num_sleeper'];?></td> 
            </tr> 
            <?php 
                } 
             ?> 
        </table> 
    </section> 
    <br><br>

    <?php for($page = 1; $page<= $number_of_page; $page++) {  ?>
    <?php    echo '<a class="register" href = "view-released-trains.php?page=' . $page . '">' . $page . ' </a>'; ?>  
    <?php } ?> 

    <br><br><br>
    <a href="admin-page.php" class="register">Back</a>
</form>
</div>

<?php include "template/footer.php" ?>

</html>