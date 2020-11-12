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
    $errors = array('validate' => '', 'seats' => '');
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

      //IF NO ERRORS THEN CHECK WHETHER SEATS ARE AVAILABLE IN DESIRED COACH
      if(! array_filter($errors)){
        $_SESSION['name'] = $name;  
        $_SESSION['age'] = $age;
        $_SESSION['gender'] = $gender;
        $train_number = $_SESSION['train_number'];
        $date = $_SESSION['date'];
        $coach = $_SESSION['coach'];
        $num_passengers = $_SESSION['num_passengers'];
        $u_name = $_SESSION['username'];
        
        // IF AVAILABLE THEN REDIRECT GET TICKET ELSE FAILURE PAGE
        $query1 = "CALL check_seats_availabilty('$train_number', '$date', '$coach', '$num_passengers')";
        if ($conn->query($query1) === FALSE) {
          $_SESSION['seats_error'] = $conn->error;
          header('Location: not-available.php');
        }
        else{
          // GENERATE PNR NUMBER & INSERT INTO TICKET
          $query1 = "CALL generate_pnr('".$_SESSION['username']."', @p1, '$coach', '$train_number', '$date'); SELECT @p1 AS pnr_no;";
          if($conn->multi_query($query1) == FALSE){
            echo $conn->error;
          }
          $conn->next_result();
          $result = $conn->store_result();      
          $pnr_no = $result->fetch_object()->pnr_no;
          $_SESSION['pnr_no'] = $pnr_no;

          // ASSIGN BERTH NO & COACH NO & INSERT INTO PASSENGER
          for($i=0; $i<$num_passengers; $i++){
            $query1 = "CALL assign_berth('$train_number', '$date', '$coach', '$name[$i]', '$age[$i]', '$gender[$i]', '$pnr_no')";
            if ($conn->query($query1) === FALSE) {
              echo $conn->error;
            }
          }

          header('Location: get-ticket.php');
         
        }
      }
    }
?>

<!DOCTYPE html>
<html lang="en">

<?php include "template/header-name.php" ?>

<div style="margin-top:100px;">
<form method="post" action="passenger-details.php" style="width: 55%;">
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
   <td> Passenger&nbsp<?php echo $i+1 ?>&nbsp&nbsp&nbsp
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
</div>

<?php include "template/footer.php" ?>

</html>
