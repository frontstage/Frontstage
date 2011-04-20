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
	$username   = isset($_POST['username']) ? $_POST['username'] : "";
	$password   = isset($_POST['password']) ? $_POST['password'] : "";
	$session_id = isset($_POST['session_id']) ? $_POST['session_id'] : "";

	$retval = mysql_query("SELECT user_id, username, terms FROM users WHERE username = '$username' AND password = '$password' AND session_id = '$session_id'");
	
	if(mysql_num_rows($retval) == 1) {
		$array = array();
		while ($row = mysql_fetch_assoc($retval)) {
			$array[]= $row;
		}
		$final = json_encode($array);
		echo $final;
	} else {
		$new = mysql_query("INSERT INTO users (
			username,
			password,
			session_id
		) VALUES (
			'$username',
			'$password',
			'$session_id'
		)");
		if ($new) {
		$retval= mysql_query("SELECT * FROM users WHERE username= '$username' AND password = '$password' AND session_id = '$session_id'");
		$array = array();
		while ($row = mysql_fetch_assoc($retval)) {
			$array[]= $row;
		}
		$final = json_encode($array);
		echo $final;
		} else {
			echo "ERROR:" . mysql_error();
		}
		
	}
 
	mysql_close($conn);
?>
