<?php
	/** MySQL database name */
	define('DB_NAME', 'corne41_audpart');
	/** MySQL database username */
	define('DB_USER', 'corne41');
	/** MySQL database password */
	define('DB_PASSWORD', '301hcilab');
	/** MySQL hostname */
	define('DB_HOST', '67.210.100.88');
 
	// Initialization
	$conn = mysql_connect(DB_HOST,DB_USER,DB_PASSWORD);
	mysql_select_db(DB_NAME, $conn);
 
	// Error checking
	if(!$conn) {
		die('Could not connect ' . mysql_error());
	}
 
	if($_POST['secret'] != "some_secret") {
		die('Nothing to see here...');
	}
 
	// Localize the POST variables
	$user_id   = isset($_POST['user_id']) ? $_POST['user_id'] : "";
	$session_id = isset($_POST['session_id']) ? $_POST['session_id'] : "";
	$info_usage = isset($_POST['info_usage']) ? $_POST['info_usage'] : "";
	$over18_verify = isset($_POST['over18_verify']) ? $_POST['over18_verify'] : "";
	$photo_record = isset($_POST['photo_record']) ? $_POST['photo_record'] : "";
	$name = isset($_POST['name']) ? $_POST['name'] : "";
	$date = isset($_POST['date']) ? $_POST['date'] : "";
	$email = isset($_POST['email']) ? $_POST['email'] : "";
	
	if (empty($info_usage)) {
		$retval = mysql_query("UPDATE users SET photo_record= '$photo_record', over18_verify= '$over18_verify', name= '$name', date= '$date', email= '$email', terms = '1' WHERE user_id = '$user_id' AND session_id = '$session_id'");
		if ($retval) {
			echo "OK";
		} else {
			echo "ERROR:" . mysql_error();
		}
		
	} else {
		$retval = mysql_query("UPDATE users SET info_usage= '$info_usage' WHERE user_id = '$user_id' AND session_id = '$session_id'");
		if ($retval) {
			echo "OK";
		} else {
			echo "ERROR:" . mysql_error();
		}
	}

 
	mysql_close($conn);
?>
