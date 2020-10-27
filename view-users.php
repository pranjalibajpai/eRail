<?php
    session_start();
    //To prevent user to access the page without login
    if(!isset($_SESSION['username'])){
        header('Location: admin-login.php');
    }
    include "config/connection.php";
    $sql = "SELECT * FROM users"; 
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
                <th>Full Name</th> 
                <th>Email</th> 
                <th>Address</th> 
            </tr> 
            <?php 
                while($rows=$result->fetch_assoc()) 
                { 
             ?> 
            <tr> 
                <td><?php echo $rows['Username'];?></td> 
                <td><?php echo $rows['Full Name'];?></td> 
                <td><?php echo $rows['Email'];?></td> 
                <td><?php echo $rows['Address'];?></td> 
            </tr> 
            <?php 
                } 
             ?> 
        </table> 
    </section> 
    <br><br>
    <a href="admin-page.php" class="register">Back</a>
</form>

<?php include "template/footer.php" ?>

</html>