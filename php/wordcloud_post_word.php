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
	$word  = isset($_POST['word']) ? $_POST['word'] : "";

	$retval= mysql_query("INSERT INTO wordcloud(
			user_id,
			session_id,
			word,
			timestamp
		) VALUES (
			'$user_id',
			'$session_id',
			'$word',
			'$timestamp'
		)",$conn);
			
	if ($retval) {
	
	$return= mysql_query("select * from wordcloud WHERE user_id = '$user_id' AND session_id = '$session_id'");
	
	$array = array();
	while ($row = mysql_fetch_assoc($return)) {
		$array[]= $row;
	}
	$final = json_encode($array);
	echo $final;
	} else {
		echo "ERROR:" . mysql_error();
	}
 
	mysql_close($conn);
?>
