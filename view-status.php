<?php
    session_start();
    include "config/connection.php";
    $errors = array('number' => '', 'date' => '', 'final' => '');
    $number = $date = '';
    $avail_ac = $avail_sleeper = '';
    if(isset($_POST['submit'])){
        $number = $_POST['number'];
        $date = $_POST['date'];
        $number = $conn->real_escape_string($number);
        $date = $conn->real_escape_string($date);
        
        if(empty($number)){
			$errors['number'] = 'Train Number is required';
        }
        if(empty($date)){
            $errors['date'] = 'Date is required';
        }  
        if(! array_filter($errors)){ 
            //CHECK VALID TRAIN
            $query1 = "SELECT * FROM train_status WHERE t_number = '$number' AND t_date = '$date'";
            $result = $conn->query($query1);
            $query2 = "SELECT * FROM train WHERE t_number = '$number' AND t_date = '$date'";
            $result2 = $conn->query($query2);
            //IF TUPLE FOUND IN TABLE PRINT STATUS
            if($result->num_rows > 0){
                $row = $result->fetch_object();
                $row1 = $result2->fetch_object();
                if($row1->num_ac == 0){
                    $avail_ac = 0;
                }
                else{
                    $avail_ac = $row1->num_ac*18 - $row->seats_b_ac;
                }
                if($row1->num_sleeper == 0){
                    $avail_sleeper = 0;
                }
                else{
                    $avail_sleeper = $row1->num_sleeper*24 - $row->seats_b_sleeper;
                }
            }
            else if($result2->num_rows > 0){
                    $errors['final'] = 'Train has been booked';
                    $avail_ac = $avail_sleeper = 0;
            }
            else{
                $errors['final'] = 'Train has not been released'; 
            }
        }    
    }
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Check Train Status</title>
</head>
<?php include "template/header.php" ?>
<style> 
    table { 
        width: 90%;
        margin: 0 auto; 
        font-size: large; 
        border: 2px solid rgb(120, 120, 120); 
    }
    td { 
        background-color: #E4F5D4; 
        border: 2px solid rgb(120, 120, 120); 
    } 

    th, td { 
        font-weight: bold; 
        border: 2px dotted rgb(120, 120, 120); 
        padding: 10px; 
        text-align: left; 
    } 
    td { 
        font-weight: lighter; 
    } 
</style> 
<div style="margin-top:200px;">
    <form style="padding:50px;" action="view-status.php" method=POST>
        <h3 class = "heading">Check Train Status</h3>
            <label>
                <p class="label-txt">TRAIN NUMBER</p>
                <input type="number" class="input" min=0 name="number" value="<?php echo htmlspecialchars($number) ?>">
                <div class="line-box">
                    <div class="line"></div>
                </div>
                <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['number'])?></p>
            </label>
            <label>
                <p class="label-txt">DATE</p>
                <input type="date" class="input" name="date" value="<?php echo htmlspecialchars($date) ?>">
                <div class="line-box">
                    <div class="line"></div>
                </div>
                <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['date'])?></p>
            </label>
            <p class= "bg-danger text-white"><?php echo htmlspecialchars($errors['final'])?></p>
        <a href="index.php" class="register">Back</a>
        <button type="submit" name="submit" value="submit">Check</button>
        <br><br>
        <h5>Seats Available</h5>
        <table>
            <tr>
                <td><h5> AC Coach </h5></td>
                <td><h5><?php echo $avail_ac ?></h5></td>
            </tr>
            <tr>
                <td><h5> Sleeper Coach</h5></td>
                <td><h5><?php echo $avail_sleeper?></h5></td>
            </tr>
        </table>
        
    </form>
</div>

<?php include "template/footer.php" ?>

</html>