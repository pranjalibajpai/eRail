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
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>


<?php include "template/footer.php" ?>

</html>