<!DOCTYPE html>
<html lang="en">
<head>
    <title>Contact Us</title>
</head>
<?php 
    if(isset($_SESSION['username']))
        include "template/header-name.php";
    else
        include "template/header.php";
?>

<div style="margin-top:150px;">
    <form style="padding:50px;">
        <h3>Pranjali Bajpai</h3><br>
        <a href="https://in.linkedin.com/in/pranjali-bajpai" class="register"><i class="fab fa-linkedin pr-1"></i>Linkedin</a>
        <a href="mailto:2018eeb1243@iitrpr.ac.in" class="register"><i class="fab fa-google pr-1"></i> Gmail</a>
        <a href="https://github.com/pranjalibajpai"class="register"><i class="fab fa-github pr-1"></i> Github</a>
        <br><br><br>
        <h3>Gazal Arora</h3><br>
        <a href="https://in.linkedin.com/in/gazal-arora-52943b167" class="register"><i class="fab fa-linkedin pr-1"></i>Linkedin</a>
        <a href="mailto:2018csb1090@iitrpr.ac.in" class="register"><i class="fab fa-google pr-1"></i> Gmail</a>
        <a href="https://github.com/Gazal1090"class="register"><i class="fab fa-github pr-1"></i> Github</a>
        <br><br><br>
        <a href="index.php" class="register">Back</a>
    </form>
    
</div>

<?php include "template/footer.php" ?>

</html>