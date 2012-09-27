import lotus.domino.*;
import java.util.zip.*;

public class JavaAgent extends AgentBase {

        public void NotesMain() {

                try {
                        Session session = getSession();
                        AgentContext agentContext =
session.getAgentContext();
                         CRC32 crc32 = new CRC32();
        crc32.update(new byte[0], 4, 0x7ffffffc);

                        // (Your code goes here)

                } catch(Exception e) {
                        e.printStackTrace();
                }
        }
}

