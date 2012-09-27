===================SNIP===========================
$ cat AdminLogin.php|less
<?php
class AdminLogin_Controller extends Santilga_Controller{

    public function  __construct() {
        $this->view->templateName = "admin";
        parent::__construct();

        $this->lang = Santilga_Language::getInstance()->getLanguage();
        $this->view->lang = $this->lang;
        $this->view->showUploadForm = false;
    }

    public function indexAction(){
       if($this->helpers->User->adminLoggedIn()){
            $this->helpers->Url->redirect("admin/about");
       }else{
            $this->helpers->Url->redirect("adminLogin/login");
       }
    }

    public function logoutAction(){
        $session = Santilga_Resource::get("session");
        if($session->adminLoggedIn){
            unset($session->admin);
            unset($session->adminId);
            unset($session->adminLoggedIn);
        }
        $this->helpers->Url->redirect("adminLogin/login");
    }

    public function loginAction(){

       $this->view->layoutFile = "loginLayout.php";

       $request = $this->request->getParams();
       $session = Santilga_Resource::get("session");
       $model = Admin_Model::getInstance();
       $error = array();


       if($post = $this->request->getPost()){

            /*$data = array('username' => $this->request->getPost('username'),
                          'password' => $this->request->getPost('password')
            );*/
            if(!empty($post["username"]) && !empty($post["password"])){

                $admin = $model->autenticate($post);
                if($admin !== null){
                    $session->admin = $admin;
                    $session->adminId = $admin->id;
                    $session->adminLoggedIn = true;
                    $this->helpers->Url->redirect("admin/about");
                }else{
                    $error[] = Santilga_Language::_("userPassMismatch", "Error:: username and/or password didn't match or you are
not admin");
                }
            }else{
                $error[] = Santilga_Language::_("userPassRequired", "Username and password must not be empty");
            }
       }
       $this->view->error = $error;
       $this->view->title = Santilga_Language::_("panelLogin", " Panel Login");
       $this->view->mainContent = $this->view->content("form", "login");
       $this->view->rightBlock = false;
    }

}
?>
================================================================
