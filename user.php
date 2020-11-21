<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] == 'admin1' || $_SESSION['username'] == 'admin'){
          header('Location: admin-page.php');
        }
    }
    else{
        header('Location: index.php');
    }
    $welcome_name = $_SESSION['username'] ?? 'Guest';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>User Page</title>
</head>
<?php include "template/header-name.php" ?>

<div style="margin-top:100px;">
<form> 
    <h3 class="heading">Welcome <?php echo $welcome_name ?></h3> <br>
    <div class="line-box">
      <div class="line"></div>
    </div><br><br>
    <a href="book-ticket.php" class="register"> Book New Ticket </a><br><br><br>
    <a href="view-trains.php" class="register">View All Trains</a><br><br><br>
    <a href="view-status.php" class="register">View Train Status</a><br><br><br>
    <a href="view-user-booking.php" class="register">View Past Bookings</a><br><br><br>
    <div class="line-box">
      <div class="line"></div>
    </div>
</form>
</div>

<?php include "template/footer.php" ?>

</html>