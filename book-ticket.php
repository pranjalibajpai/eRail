<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] == 'admin1'){
          header('Location: admin-login.php');
        }
    }
    else{
        header('Location: index.php');
    }

    include "config/connection.php";
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>

<form action="release-train.php" method="POST">
    <h3 class="heading">Book Ticket</h3> <br>
    <label>
    <p class="label-txt">TRAIN NUMBER</p>
    <input type="number" class="input" min=0 name="train_number" >
    <div class="line-box">
        <div class="line"></div>
    </div>
    </label>
    <label>
    <p class="label-txt">DATE</p>
    <input type="date" class="input" name="date">
    <div class="line-box">
        <div class="line"></div>
    </div>
    </label>
    <label>
    <p class="label-txt">COACH&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
      <input type="radio" name="coach" value="ac">&nbsp&nbsp&nbspAC</input>&nbsp&nbsp&nbsp
      <input type="radio" name="coach" value="sleeper">&nbsp&nbsp&nbspSLEEPER</input></p>
    </label><br>
    <label>
    <p class="label-txt">NUMBER OF PASSENGERS</p>
    <input type="number" class="input" min=1 name="num_passengers">
    <div class="line-box">
        <div class="line"></div>
    </div>
    </label>

    <br><br><br>
    <a href="user.php" class="register">Back</a>
    <button type="submit" name="book" value="submit">Book</button>
</form>

<?php include "template/footer.php" ?>

</html>