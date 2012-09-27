import gnu.java.security.util.PRNG;

class PRNGTest {
   public static void main(String args[])
      {
      long t = System.currentTimeMillis();

      System.out.println("Time in ms is " + t);

      PRNG prng = PRNG.getInstance();

      byte buffer[] = new byte[40];

      prng.nextBytes(buffer, 0, buffer.length);

      for(int i = 0; i != buffer.length; ++i)
         {
         // There must be an easier way to do this (right?)
         int intval = buffer[i];

         if(intval <= 0)
            intval += 256;

         String s = Integer.toHexString(intval);

         if(s.length() == 1)
            s = "0" + s;

         System.out.print(s);
         }
      System.out.println("");
      }
   };
