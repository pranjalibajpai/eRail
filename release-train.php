<?php
    session_start();
    //To prevent user to access the page without login
    if(!isset($_SESSION['username'])){
        header('Location: admin-login.php');
    }
    include "config/connection.php";

    $errors = array('train_number' => '', 'date' => '', 'num_ac' => '', 'num_sleeper' => '');
    $train_number = $date = $num_ac = $num_sleeper = ''; 
   
    if(isset($_POST['release'])){
        $train_number = $_POST['train_number'];
        $date = $_POST['date'];;
        $num_ac = $_POST['num_ac'];
        $num_sleeper = $_POST['num_sleeper'];

        if(empty($train_number)){
			$errors['train_number'] = 'Train Number is required';
        }
        if(empty($date)){
			$errors['date'] = 'Date is required';
        }
        if(empty($num_ac)){
			$errors['num_ac'] = 'Please enter numer of AC Coaches';
        }
        if(empty($num_sleeper)){
			$errors['num_sleeper'] = 'Please enter numer of Sleeper Coaches';
        }

        //***TODO -- CHECK BEFORE RELEASING WHETHER N SAME DATE SAME TRAIN NUMBER IS NOT THERE */
    }
    $welcome_name = $_SESSION['username'] ?? 'Guest';
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>

<form action="release-train.php" method="POST">
    <h3 class="heading">Release New Train</h3> <br>
    <label>
    <p class="label-txt">TRAIN NUMBER</p>
    <input type="number" class="input" name="train_number" value="<?php echo htmlspecialchars($train_number) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['train_number'])?></p>
    </label>
    <label>
    <p class="label-txt">DATE</p>
    <input type="date" class="input" name="date" value="<?php echo htmlspecialchars($date) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['date'])?></p>
    </label>
    <label>
    <p class="label-txt">NUMBER OF AC COACHES</p>
    <input type="number" class="input" name="num_ac" value="<?php echo htmlspecialchars($num_ac) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['num_ac'])?></p>
    </label>
    <label>
    <p class="label-txt">NUMBER OF SLEEPER COACHES</p>
    <input type="number" class="input" name="num_sleeper" value="<?php echo htmlspecialchars($num_sleeper) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['num_sleeper'])?></p>
    </label>
    <a href="admin-page.php" class="register">Back</a>
    <button type="submit" name="release" value="submit">Release</button>
</form>

<?php include "template/footer.php" ?>

</html>