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
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>

<form style= "width: 60%;">
<h3><?php echo $_SESSION['username'] ?>, we regret the inconvenience caused.</h3>
<h5 ><?php if (isset($_SESSION['seats_error'])) echo $_SESSION['seats_error'];?></h5><br>
<a href = "user.php" class="register">Go Back</a>
</form>

<?php include "template/footer.php" ?>

</html>