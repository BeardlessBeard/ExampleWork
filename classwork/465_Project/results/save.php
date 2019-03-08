<?php
// FIXME: This only works one time. If a professor edits and then resubmits a form, they're 
// screwed.

// Connecting to database
$conn=mysqli_connect('dbs.eecs.utk.edu', 'bbeard1', 'password', 'cs465_bbeard1');
if($conn->connect_error){
    echo '<script>console.log("No Connection")</script>';
    die("Failed to connect to MySQL: ($conn->connect_errno) $conn->connect_error");
}

// Capturing class and outcome
$class = addslashes($_POST['classes']);
$outcome = addslashes($_POST['outcomes']);
echo 'class: '.$class.'<br>';
echo 'outcome: '.$outcome.'<br><br>';

// Capturing exceed, meet, and notMeet student numbers
$exceedStudents=addslashes($_POST['exceedStudents']);
$meetStudents=addslashes($_POST['meetStudents']);
$notMeetStudents=addslashes($_POST['notMeetStudents']);
echo 'exceedStudents: '.$exceedStudents.'<br>';
echo 'meetStudents: '.$meetStudents.'<br>';
echo 'notMeetStudents: '.$notMeetStudents.'<br>';
echo '<br>';

// Finding sectionId for given professor/course
// Note: This is currently hardcoded to the professor 'lilY'
$sectionId = mysqli_query($conn,
'select sectionId from Instructors natural join SectionsCurrent natural join Courses where instructorId = "lilY" and courseId = "'.$class.'";');
$sectionId = mysqli_fetch_array($sectionId)[0];
echo 'sectionId: '.$sectionId.'<br><br>';

// Finding the major for the given professor/course
$major = mysqli_query($conn,
    'select outcomeMajor from Outcomes where outcomeId = "'.$outcome.'";');
$major = mysqli_fetch_array($major)[0];
echo 'major: '.$major.'<br><br>';

// Inserting exceeds, meets, and notMeets into table
mysqli_query($conn, 'INSERT into OutcomeResults values ("'.$sectionId.'", "'.$major.'", "'.$outcome.'", "1", "'.$exceedStudents.'");');
mysqli_query($conn, 'INSERT into OutcomeResults values ("'.$sectionId.'", "'.$major.'", "'.$outcome.'", "2", "'.$meetStudents.'");');
mysqli_query($conn, 'INSERT into OutcomeResults values ("'.$sectionId.'", "'.$major.'", "'.$outcome.'", "3", "'.$notMeetStudents.'");');

// Inserting Assessments

foreach($_POST['assessmentType'] as $key => $val){
    echo 'Assessment '.$key.'<br>';
    $val = addslashes($val);
    echo 'assessmentType: '.$val.'<br>';

    // If other selected, insert assessment type into database and get assessmentId
    if($val == 'other'){
        $val=$_POST['customAssessment'][$key];
        echo 'custom val is '.$val.'<br>';
        // Insert new assessment if necessary
        mysqli_query($conn, 
        'insert into AssessmentTypes (assessmentType) values ("'.$val.'");');
        $assessmentId = mysqli_insert_id($conn);
    }
    // Else assessment already in database, find assessmentId
    else{
        $assessmentId = mysqli_query($conn,
        'select assessmentId from AssessmentTypes where assessmentType = "'.$val.'";');
        $assessmentId = mysqli_fetch_array($assessmentId)[0];
    }
    echo 'assessmentId: '.$assessmentId.'<br>';
    

    // Get posts
    $weight = $_POST['assessmentWeight'][$key];
    echo 'weight: '.$weight.'<br>';

    $desc = $_POST['assessmentDesc'][$key];
    echo 'description: '.$desc.'<br>';

    $exceeds = $_POST['exceeds'][$key];
    echo 'exceeds: '.$exceeds.'<br>';

    $meets = $_POST['meets'][$key];
    echo 'meets; '.$meets.'<br>';

    $notMeets = $_POST['notMeets'][$key];
    echo 'notMeets; '.$notMeets.'<br>';

    // FIXME: Hardcoded rubricName and instructorId b/c I don't know them
    // insert into RubricNames
    mysqli_query($conn, 
    'insert into RubricNames (rubricName, outcomeId, instructorId) values ("UserMadeRubric", "'.$outcome.'", "lilY");');

    // Find rubricId
    $rubricId = mysqli_insert_id($conn);
    echo 'rubricId: '.$rubricId.'<br>';

    // insert into Rubrics
    mysqli_query($conn,
    'insert into Rubrics values ('.$rubricId.', 1, "'.$exceeds.'");');
    mysqli_query($conn,
    'insert into Rubrics values ('.$rubricId.', 2, "'.$meets.'");');
    mysqli_query($conn,
    'insert into Rubrics values ('.$rubricId.', 3, "'.$notMeets.'");');

    mysqli_query($conn,
        'insert into Assessments values ('.$sectionId.', '.$assessmentId.', "'.$desc.'", "'.$major.'", "'.$outcome.'", '.$weight.', '.$rubricId.');');
    echo '<br>';
    echo '<br>';

}

foreach($_POST['strengths'] as $key => $strengths){
    $weak = $_POST['weak'][$key];
    $sugg = $_POST['sugg'][$key];

    mysqli_query($conn,
    'insert into Narratives values ('.$sectionId.', "'.$major.'", "'.$outcome.'", "'.$strengths.'", "'.$weak.'", "'.$sugg.'");');
}
mysqli_close($conn);
?>
