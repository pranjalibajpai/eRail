<?php
    session_start();
    //To prevent user to access the page without login
    if(isset($_SESSION['username'])){
        if($_SESSION['username'] == 'admin1' || $_SESSION['username'] == 'admin'){
          header('Location: admin-login.php');
        }
    }
    else{
        header('Location: index.php');
    }

    include "config/connection.php";
    $num_passengers = $_SESSION['num_passengers'];
    $errors = array('validate' => '');
    $name = $age = $gender = [];
    for($i = 0; $i < $num_passengers; $i++){
      $name[$i] = $age[$i] = $gender[$i] = '';
    }
   
    if(isset($_POST['check'])){
      $name = $_POST['name'];
      $age = $_POST['age'];
      $gender = $_POST['gender'];
      
      if(in_array('', $name, true) || in_array('', $age, true) || in_array('', $gender, true)){
        $errors['validate'] = 'Please fill details of all the passengers!';
      }

      //IF NO ERRORS THEN CHECK SEATS ARE AVAILABLE IN DESIRED COACH
      if(! array_filter($errors)){
        $_SESSION['name'] = $name;  
        $_SESSION['age'] = $age;
        $_SESSION['gender'] = $gender;
        
        // TODO - CHECK SEATS ARE AVAILABLE***
        // IF AVAILABLE THEN REDIRECT GET TICKET ELSE FAILURE PAGE
        // THEN REDIRECT TO USER PAGE.
        $available = FALSE;
        if($available){
          header('Location: get-ticket.php');
        }
        else{
          header('Location: not-available.php');
        }
      }
    }
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>

<form method="post" action="passenger-details.php">
  <h3> Enter Details Of Passengers</h3><br>
  <table>
    <tr> 
        <th></th>
        <th>Name</th> 
        <th>Age</th> 
        <th>Gender</th> 
    </tr> 
  <?php for($i = 0; $i < $num_passengers; $i++){ ?>
   <tr>
   <td>
   <?php echo $i+1 ?>&nbsp&nbsp&nbsp
   </td>
   <td>
	<input type="text" name="name[]" placeholder="Enter name" value = "<?php echo $name[$i] ?>">&nbsp&nbsp&nbsp
	</td>
	<td>
	<input type="number" name="age[]" placeholder="Enter Age" value = "<?php echo $age[$i] ?>">&nbsp&nbsp&nbsp
	</td>
	<td>
	<select name="gender[]">
    <option value="Female" <?php echo (isset($gender[$i]) && $gender[$i] === 'Female') ? 'selected' : ''; ?>>Female</option>
    <option value="Male" <?php echo (isset($gender[$i]) && $gender[$i] === 'Male') ? 'selected' : ''; ?>>Male</option>
	</select>
	</td>
   </tr>
  <?php } ?>
  </table>
    <br><br>

  <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['validate'])?></p>

  <a href="book-ticket.php" class="register">Back</a>
  <button type="submit" name="check" value="submit">Check Availability</button>
 </form>

<?php include "template/footer.php" ?>

</html>
