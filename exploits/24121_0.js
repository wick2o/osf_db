var snoopWin;

function run() {
	snoopWin = window.open('http://www.google.com/','snoopWindow','width=640,height=480');
	snoopWin.blur();
	setTimeout("snoopy()", 5000);	
}

function snoopy() {
	alert(snoopWin.location);
	setTimeout("snoopy()", 5000);
}