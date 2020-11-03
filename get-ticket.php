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

<form>
    <h3>Congratulations!</h3>
    <h4>Your ticket has been successfully booked</h2>
    <!-- YOUR PNR NUMBER IS -->
    <!-- NAME OF BOOKING AGENTS -->
    <!-- NAME OF PASSENGERS -->
    <!-- BERTH NUMBER COACH NUMBER -->
    <!-- CLASS OF ALL PASSENGERS -->
    <!-- BOOKED BY -->
    <!-- TIMESTAMP -->
    <br>
    <button onclick="window.print()">Get Your Ticket</button>
    <a href="user.php" class= "register">Home</a>
</form>


<?php include "template/footer.php" ?>

</html>
