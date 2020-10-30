<?php
    session_start();
    //To prevent user to access the page without login
    if(!isset($_SESSION['username'])){
        header('Location: index.php');
    }
    include "config/connection.php";

    // FOR PAGINATION
    $sql = "SELECT * FROM trains ORDER BY train_date";

    include "template/pagination.php";  
    
    $sql = "SELECT *FROM trains ORDER BY train_date LIMIT " . $page_first_result . ',' . $results_per_page;  
    $result = $conn->query($sql); 
    $conn->close();  

?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>
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

<form style="width: 80%;">
    <h3 class="heading">Released Trains</h3> <br>
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
                <td><?php echo $rows['train_number'];?></td> 
                <td><?php echo $rows['train_date'];?></td> 
                <td><?php echo $rows['num_ac_coach'];?></td> 
                <td><?php echo $rows['num_sleeper_coach'];?></td> 
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

<?php include "template/footer.php" ?>

</html>