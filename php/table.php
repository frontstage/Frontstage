
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

$retval = mysql_query("SELECT users.username,clicker.image_id,clicker.timestamp FROM clicker INNER JOIN users WHERE clicker.user_id= users.user_id");

$num=mysql_numrows($retval);
mysql_close();

echo "<b><center>Database Output</center></b><br><br>";

$i=0;
while ($i < $num) {

$field1=mysql_result($retval,$i,"username");
$field2=mysql_result($retval,$i,"image_id");
$field3=mysql_result($retval,$i,"timestamp");

echo "<b>$field1 
$field2</b><br>$field3<br>";

$i++;
}

?>