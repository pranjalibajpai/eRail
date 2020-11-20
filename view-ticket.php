<?php
    session_start();
    include "config/connection.php";
    $errors = array('pnr' => '');
    $pnr = '';
    if(isset($_POST['submit'])){
        $pnr = $_POST['pnr'];
        $pnr = $conn->real_escape_string($pnr);

        //CHECK VALID PNR
        $query1 = "CALL check_valid_pnr('$pnr');";
        if ($conn->query($query1) === FALSE) {
            $errors['pnr'] = $conn->error;
        }

        if(! array_filter($errors)){
            $_SESSION['view_pnr'] = $pnr;
            $conn->close();
            header('Location: view-pnr-details.php');
        }
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>View Ticket</title>
</head>
<?php include "template/header.php" ?>

<div style="margin-top:200px;">
    <form style="padding:50px;" action="view-ticket.php" method=POST>
    
        <label>
            <p class="label-txt">ENTER YOUR UNIQUE 10-DIGIT PNR NUMBER</p>
            <input type="text" class="input" name="pnr" maxlength=12 value="<?php echo htmlspecialchars($pnr) ?>"> 
            <div class="line-box">
            <div class="line"></div>
            </div>
            <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['pnr'])?></p>
        </label>
        <a href="index.php" class="register">Back</a>
        <button type="submit" name="submit" value="submit">View Ticket</button>
    </form>
</div>

<?php include "template/footer.php" ?>

</html>