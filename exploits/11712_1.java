import netscape.javascript.*;
import com.opera.*;

public class Opera754EcmaScriptApplet extends java.applet.Applet{

	public void start()? {
		PluginContext pc = (PluginContext)this.getAppletContext();

		int jswin= pc.getJSWindow();
		int esrun= pc.getESRuntime();
		EcmaScriptObject eso4 = EcmaScriptObject.getObject (jswin,1);
		try {
			JSObject js = JSObject.getWindow(this);
			System.out.println(js);
		}
		catch (Exception e) {
		e.printStackTrace();
		}
	}
}
