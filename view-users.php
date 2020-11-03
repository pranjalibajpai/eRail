<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] != 'admin1' || $_SESSION['username'] == 'admin'){
          header('Location: user.php');
        }
    }
    else{
        header('Location: admin-login.php');
    }
    
    include "config/connection.php";
    
    // FOR PAGINATION
    $sql = "SELECT * FROM user";
    
    include "template/pagination.php";

    $sql = "SELECT *FROM user LIMIT " . $page_first_result . ',' . $results_per_page;  
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
    <h3 class="heading">Registered Users</h3> <br>
    <section>
        <table> 
            <tr> 
                <th>Username</th> 
                <th>Name</th> 
                <th>Email</th> 
                <th>Address</th> 
            </tr> 
            <?php 
                while($rows=$result->fetch_assoc()) 
                { 
             ?> 
            <tr> 
                <td><?php echo $rows['username'];?></td> 
                <td><?php echo $rows['name'];?></td> 
                <td><?php echo $rows['email'];?></td> 
                <td><?php echo $rows['address'];?></td> 
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