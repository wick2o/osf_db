  // Step 1: Generate the two FormsAuthenticationTickets
      FormsAuthenticationTicket  ticket1 = new FormsAuthenticationTicket("admin", true, 10000);
      FormsAuthenticationTicket ticket2 = new FormsAuthenticationTicket(2, "admin", System.DateTime.Now, System.DateTime.MaxValue, true, "Registered
Users;Subscribers;Administrators");


      // Step 2: Encrypt the FormsAuthenticationTickets
      string cookie1 = ".DOTNETNUKE=" + FormsAuthentication.Encrypt(ticket1);
      string cookie2 = "portalroles=" + FormsAuthentication.Encrypt(ticket2);

