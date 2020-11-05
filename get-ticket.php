<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] == 'admin1' || $_SESSION['username'] == 'admin'){
          header('Location: admin-login.php');
        }
    }
    else{
        header('Location: index.php');
    }

?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>
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
<form style = "width: 60%;">
    <h3>Congratulations!</h3>
    <h4>Your ticket has been successfully booked</h2><br><br>
    <h5>Booking Details </h5>
    <table>
        <tr>
            <td><h5> PNR NUMBER </h5></td>
            <td><h5><?php echo $_SESSION['pnr_no'] ?></h5></td>
        </tr>
        <tr>
            <td><h5> Coach Type</h5></td>
            <td><h5><?php echo $_SESSION['coach'] ?></h5></td>
        </tr>
        <tr>
            <td><h5> Train Number</h5></td>
            <td><h5><?php echo $_SESSION['train_number'] ?></h5></td>
        </tr>
        <tr>
            <td><h5> Date Of Journey</h5></td>
            <td><h5><?php echo $_SESSION['date'] ?></h5></td>
        </tr>
        <tr>
            <td><h5> Number Of Passengers</h5></td>
            <td><h5><?php echo $_SESSION['num_passengers'] ?></h5></td>
        </tr>
        <tr>
            <td><h5> Booked By</h5></td>
            <td><h5><?php echo $_SESSION['username'] ?></h5></td>
        </tr>
        <tr>
            <td><h5> Booked On :</h5></td>
            <td><h5><?php echo $_SESSION['num_passengers'] ?></h5></td>
        </tr>
    </table><br><br>
    <h5> Passenger Details </h5>
    
    
    <!-- NAME OF PASSENGERS -->
    <!-- BERTH NUMBER COACH NUMBER -->
    <!-- CLASS OF ALL PASSENGERS -->
    <!-- BOOKED BY -->
    <!-- TIMESTAMP -->
    <br>
    <h5> Have a Safe Journey! </h5>
    <a href="user.php" class= "register">Home</a>
    <button onclick="window.print()">Print Ticket</button>
    
</form>


<?php include "template/footer.php" ?>

</html>
