<?php
$conn=mysqli_connect("dbs.eecs.utk.edu", "bbeard1", "password", "cs465_bbeard1");

if($conn->connect_error){
    echo '<script>console.log("No Connection")</script>';
    die("Failed to connect to MySQL: ($conn->connect_errno) $conn->connect_error");
}

$username=$_POST["username"];
$pwd=$_POST["pwd"];

$table=mysqli_query($conn, "select instructorId, instructorPassword from Instructors where instructorId = \"".$username."\" and instructorPassword = \"".$pwd."\";");

if(mysqli_num_rows($table) != 1){
    header( 'Location: http://web.eecs.utk.edu/~bbeard1/465_Project/login/loginFailed.html');
}else{
    header( 'Location: http://web.eecs.utk.edu/~bbeard1/465_Project/results/results.html');
}

mysqli_close($conn);
?>
