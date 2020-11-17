<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] != 'admin1' && $_SESSION['username'] != 'admin'){
          header('Location: user.php');
        }
    }
    else{
        header('Location: admin-login.php');
    }

    include "config/connection.php";
    // FOR PAGINATION
    $sql = "SELECT * FROM ticket";
    include "template/pagination.php";
    $sql = "SELECT * FROM ticket LIMIT " . $page_first_result . ',' . $results_per_page;  
    $result = $conn->query($sql); 
    $conn->close();
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header.php" ?>
<style> 
    table { 
        width: 90%;
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
        text-align: left; 
    } 
    td { 
        font-weight: lighter; 
    } 
</style>
<div style="margin-top:200px;">
    <form style = "width: 80%;">
        <h5>Booking Details</h5>
        <section>
            <table> 
                <tr> 
                    <th>PNR No</th> 
                    <th>Train Number</th> 
                    <th>Date</th> 
                    <th>Coach</th> 
                    <th>Booked By</th> 
                    <th>Booked At</th> 
                </tr> 
                <?php 
                    while($rows=$result->fetch_assoc()) 
                    { 
                ?> 
                <tr> 
                    <td><h5><?php echo $rows['pnr_no'];?></h5></td> 
                    <td><h5><?php echo $rows['t_number'];?></h5></td> 
                    <td><h5><?php echo $rows['t_date'];?></h5></td> 
                    <td><h5><?php echo $rows['coach'];?></h5></td>
                    <td><h5><?php echo $rows['booked_by'];?></h5></td> 
                    <td><h5><?php echo $rows['booked_at'];?></h5></td>  
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
        <a href="admin-page.php" class= "register">Back</a>

    </form>
</div>

<?php include "template/footer.php" ?>

</html>