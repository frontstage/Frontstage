<?php
	/** MySQL database name */
	define('DB_NAME', 'corne41_audpart');
	/** MySQL database username */
	define('DB_USER', 'corne41');
	/** MySQL database password */
	define('DB_PASSWORD', '301hcilab');
	/** MySQL hostname */
	define('DB_HOST', '67.210.100.88');
 	
	date_default_timezone_set("UTC");
 	$timestamp= date("Y-m-d H:i:s");
 	
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
	$session_id  = isset($_POST['session_id']) ? $_POST['session_id'] : "";
	$image_id  = isset($_POST['image_id']) ? $_POST['image_id'] : "";

	$retval= mysql_query("INSERT INTO clicker(
			user_id,
			session_id,
			image_id,
			timestamp
		) VALUES (
			'$user_id',
			'$session_id',
			'$image_id',
			'$timestamp'
		)",$conn);
			
	if ($retval) {
	echo "OK";
	} else {
		echo "ERROR:" . mysql_error();
	}
 
	mysql_close($conn);
?>
