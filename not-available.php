<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] == 'admin1'){
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
<h3>WE REGRET THE INCONVENIENCE CAUSED</h3>
<h4>It looks like the seats requested by you are not available</h4><br>
<h4>THANKS FOR YOUR PATIENCE!</h4><br>
<a href = "user.php" class="btn btn-outline-danger">Go Back</a>
</form>

<?php include "template/footer.php" ?>

</html>