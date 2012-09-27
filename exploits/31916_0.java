BasicService basicService = (BasicService)    ServiceManager.lookup("javax.jnlp.BasicService");

URL mike = new URL("file:\\C:\\music.rm");

basicService.showDocument(mike);
