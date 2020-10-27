<?php

    include "config/connection.php";

    $errors = array('fullname' => '', 'username' => '', 'email' => '', 'address' => '', 'password' => '', 'confirmp' => '');
    $fullname = $username = $email = $address = $password = $confirmp = '';

    if(isset($_POST['register'])){
        $fullname = $_POST['fullname'];
        $username = $_POST['username'];
        $email = $_POST['email'];
        $address = $_POST['address'];
        $password = $_POST['password'];
        $confirmp = $_POST['confirmp'];

        if(empty($fullname)){
			$errors['fullname'] = 'Full Name is required';
		} 
		if(empty($username)){
			$errors['username'] = 'Username is required';
        }
        else{
			if(!preg_match('/^[a-zA-Z]+$/', $username)){
				$errors['username'] .= 'Username must consist of letters only';
            }

            //CHECK USERNAME ALREADY EXISTED 
            $username = $conn->real_escape_string($username);
            $query2 = "SELECT * FROM users WHERE Username = '$username' ";
            $result = $conn->query($query2);


            if($result->num_rows > 0){
                $errors['username'] .= 'Username already taken';
            }
		}
        if(empty($email)){
			$errors['email'] = 'An Email is required';
        }
        else {
            if(!filter_var($email, FILTER_VALIDATE_EMAIL)){
                $errors['email'] = 'Email must be a valid email address';
            }

            //CHECK EMAIL ALREADY REGISTERED
            $email = $conn->real_escape_string($email);
            $query3 = "SELECT * FROM users WHERE Email = '$email' ";
            $result = $conn->query($query3);


            if($result->num_rows > 0){
                $errors['email'] .= 'Email Already Registered';
            }
        }    
        
        if(empty($address)){
			$errors['address'] = 'Address is required';
        }
        if(empty($password)){
			$errors['password'] = 'Password is required';
        }
        else if(strlen($password) < 8){
            $errors['password'] .= 'Password must be minimum 8 characters';
        }

        if(empty($confirmp) || $confirmp != $password){
            $errors['confirmp'] = 'Confirm your password again';
        } 
        
        // When no errors redirect to index.php and insert values in user table
        if(! array_filter($errors)){

            $query1 = "INSERT INTO users VALUES ('$fullname', '$username', '$email', '$address', '$password')";
            if ($conn->query($query1) === TRUE) {
                echo "New record created successfully";
              } else {
                echo "Error: " . $query1 . "<br>" . $conn->error;
              }
              
            $conn->close();
            header('Location: index.php');
        }
    }

?>



<!DOCTYPE html>
<html lang="en">

<?php include "template/header.php" ?>

<form action="register.php" method="POST">
    <h3 class="heading">Register on eRail</h3>
  <label>
    <p class="label-txt">FULL NAME</p>
    <input type="text" class="input" name="fullname" value="<?php echo htmlspecialchars($fullname) ?>">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['fullname'])?></p>
  </label>
  <label>
    <p class="label-txt">USERNAME</p>
    <input type="text" class="input" name="username" value="<?php echo htmlspecialchars($username) ?>">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['username'])?></p>
  </label>
  <label>
    <p class="label-txt">EMAIL</p>
    <input type="email" class="input" name="email" value="<?php echo htmlspecialchars($email) ?>">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['email'])?></p>
  </label>
  <label>
    <p class="label-txt">ADDRESS</p>
    <input type="text" class="input" name="address" value="<?php echo htmlspecialchars($address) ?>">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['address'])?></p>
  </label>
  <label>
    <p class="label-txt">PASSWORD</p>
    <input type="password" class="input" name="password" value="<?php echo htmlspecialchars($password) ?>">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['password'])?></p>
  </label>
  <label>
    <p class="label-txt">CONFIRM PASSWORD</p>
    <input type="password" class="input" name="confirmp" value="<?php echo htmlspecialchars($confirmp) ?>">
    <div class="line-box">
      <div class="line"></div>
    </div>
    <p class= "bg-danger"><?php echo htmlspecialchars($errors['confirmp'])?></p>
  </label>
  <button type="submit" name="register" value="submit">Register</button>
</form>

<?php include "template/footer.php" ?>

</html>