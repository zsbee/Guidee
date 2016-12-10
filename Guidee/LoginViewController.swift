import UIKit
import FirebaseFacebookAuthUI
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile","user_photos"]
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            // ...
            if error != nil {
                return
            }
            if let user = user {
                DataController.sharedInstance.createUserWithID(firUser: user)
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonWidth:CGFloat = 225
        let buttonHeight:CGFloat = 45
        loginButton.frame = CGRect(x: self.view.frame.width/2.0 - buttonWidth/2.0, y: self.view.frame.height/2.0 - buttonHeight/2.0, width: buttonWidth, height: buttonHeight)
    }
}
