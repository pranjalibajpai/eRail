<!DOCTYPE html>
<html lang="en">
<head>
    <title>About Us</title>
</head>
<?php 
    session_start();
    if(isset($_SESSION['username']))
        include "template/header-name.php";
    else
        include "template/header.php";
?>

<div style="margin-top:200px;">
    <form style="padding:50px;">
        <h3>About Us</h3><br>
        <p>This online portal for railway reservation is developed by Pranjali Bajpai & Gazal Arora as a course project for CS301 Database Management System course at IIT Ropar in the Fall Semester of 2020 under the guidance of <a href="http://cse.iitrpr.ac.in/~gunturi/">Prof.Viswanath Gunturi</a>.</p>
        <br>
        <a href="index.php" class="register">Back</a>
    </form>
    
</div>

<?php include "template/footer.php" ?>

</html>