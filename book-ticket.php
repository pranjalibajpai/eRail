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
    include "config/connection.php";
    $errors = array('train_number' => '', 'date' => '', 'num_passengers' => '', 'validate' => '');
    $train_number = $date = $coach = $num_passengers = ''; 

   
    if(isset($_POST['next'])){
        $train_number = $_POST['train_number'];
        $date = $_POST['date'];
        $coach = $_POST['coach'];
        $num_passengers = $_POST['num_passengers'];

        if(empty($train_number)){
			$errors['train_number'] = 'Train Number is required';
        }
        if(empty($date)){
			$errors['date'] = 'Date is required';
        }
        if(empty($num_passengers)){
			$errors['num_passengers'] = 'Enter Number Of Passengers';
        }

        // IF NO PREVIOUS ERRORS THEN CHECK VALIDITY OF TRAIN NUMBER & DATE
	if(! array_filter($errors)){
		$train_number = $conn->real_escape_string($train_number);
		$date = $conn->real_escape_string($date);
		$query = "CALL check_valid_train('$train_number', '$date')";
		if ($conn->query($query) === FALSE) {
		    $errors['validate'] = $conn->error;
		}
	}

        // IF NO ERRORS ENTER DETAILS OF PASSENGER
        if(! array_filter($errors)){
            $_SESSION['train_number'] = $train_number;
            $_SESSION['date'] = $date;
            $_SESSION['coach'] = $coach;
            $_SESSION['num_passengers'] = $num_passengers;
            header('Location: passenger-details.php');
        }
    }   
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Book Ticket</title>
</head>
<?php include "template/header-name.php" ?>

<div style="margin-top:100px;">
<form action="book-ticket.php" method="POST">
    <h3 class="heading">Book Ticket</h3> <br>
    <label>
    <p class="label-txt">TRAIN NUMBER</p>
    <input type="number" class="input" min=0 name="train_number" value="<?php echo htmlspecialchars($train_number) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['train_number'])?></p>
    </label>
    <label>
    <p class="label-txt">DATE</p>
    <input type="date" class="input" name="date" value="<?php echo htmlspecialchars($date) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['date'])?></p>
    </label>
    <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['validate'])?></p>
    <label>
    <p class="label-txt">COACH&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp
      <input type="radio" name="coach" value="ac" checked>&nbsp&nbsp&nbspAC</input>&nbsp&nbsp&nbsp
      <input type="radio" name="coach" value="sleeper">&nbsp&nbsp&nbspSLEEPER</input></p><br>
    </label>
    <label>
    <p class="label-txt">NUMBER OF PASSENGERS</p>
    <input type="number" class="input" min=1 name="num_passengers" value="<?php echo htmlspecialchars($num_passengers) ?>">
    <div class="line-box">
        <div class="line"></div>
    </div>
    <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['num_passengers'])?></p>
    </label>
    <br>
    <a href="user.php" class="register">Back</a>
    <button type="submit" name="next" value="submit">Next</button>
</form>
</div>

<?php include "template/footer.php" ?>

</html>
