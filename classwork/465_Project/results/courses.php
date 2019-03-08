<?php

/*print($argv[0]."\n");*/
/*print($argv[1]."\n");*/

$conn=mysqli_connect('dbs.eecs.utk.edu', 'bbeard1', 'password', 'cs465_bbeard1');
if($conn->connect_error){
    echo '<script>console.log("No Connection")</script>';
    die("Failed to connect to MySQL: ($conn->connect_errno) $conn->connect_error");
}

$courseId = mysqli_query($conn, "select courseId from SectionsCurrent natural join Instructors where instructorId = '$argv[1]';");
//$courseId = mysqli_query($conn, 'select courseId from SectionsCurrent natural join Instructors where instructorId = "2pac";');
$courseId = mysqli_fetch_array($courseId)[0];

/*foreach($courseId as $course){*/
print($courseId."\n");
/*}*/
?>
