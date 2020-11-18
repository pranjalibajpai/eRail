<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] != 'admin1' && $_SESSION['username'] != 'admin'){
          header('Location: index.php');
        }
    }
    else{
        header('Location: admin-login.php');
    }
    $welcome_name = $_SESSION['username'] ?? 'Guest';
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Page</title>
</head>
<?php include "template/header-name.php" ?>

<div style="margin-top:100px;">
<form> 
    <h3 class="heading">Welcome <?php echo $welcome_name ?></h3> <br>
    <div class="line-box">
      <div class="line"></div>
    </div><br><br>
    <a href="release-train.php" class="register"> Release New Train </a><br><br><br>
    <a href="view-trains.php" class="register">View Trains</a><br><br><br>
    <a href="view-users.php" class="register">View Registered Users</a><br><br><br>
    <a href="view-bookings.php" class="register">View All Bookings</a><br><br><br>
    <div class="line-box">
      <div class="line"></div>
    </div>
</form>
</div>
  
<?php include "template/footer.php" ?>

</html>