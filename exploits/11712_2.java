import sun.misc.*;
import java.util.Enumeration;

public class Opera754LauncherApplet extends java.applet.Applet{

	public void start()? {
		URLClassPath o = Launcher.getBootstrapClassPath();
		for (int i = 0; i < o.getURLs().length; i++) {
			System.out.println(o.getURLs()[i]);
		}
	}
}
