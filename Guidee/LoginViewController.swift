import UIKit
import FirebaseFacebookAuthUI
import FBSDKLoginKit
import Firebase
import Onboard

class LoginViewController: OnboardingContentViewController, FBSDKLoginButtonDelegate {
    
    let discoverLabel: UILabel = UILabel()
    var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.discoverLabel.textColor = UIColor.init(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.3)
        self.discoverLabel.font = UIFont.systemFont(ofSize: 52, weight: UIFontWeightHeavy)
        self.discoverLabel.text = "Discover Experiences!"
        self.discoverLabel.numberOfLines = 0
        
        loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile","user_photos"]
        
        let constH = NSLayoutConstraint.constraints(withVisualFormat: "H:[loginButton(57)]", options: .alignAllCenterX, metrics: nil, views: ["loginButton": loginButton])
        let constW = NSLayoutConstraint.constraints(withVisualFormat: "V:[loginButton(281)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["loginButton": loginButton])

        loginButton.addConstraints(constH)
        loginButton.addConstraints(constW)
        
        self.view.addSubview(loginButton)
        self.view.addSubview(discoverLabel)
        self.view.setNeedsLayout()
        
        UIApplication.shared.statusBarStyle = .lightContent
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
            
            UIApplication.shared.statusBarStyle = .default
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logged out")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let buttonHeight:CGFloat = 45
        loginButton.frame = CGRect(x: self.view.frame.width/2.0 - loginButton.intrinsicContentSize.width/2.0-10, y: self.view.frame.height - buttonHeight - 100, width: loginButton.intrinsicContentSize.width + 20, height: buttonHeight)
        
        discoverLabel.preferredMaxLayoutWidth = self.view.frame.width - 2*16
        discoverLabel.frame = CGRect(x: 16, y: self.view.frame.height/2 - discoverLabel.intrinsicContentSize.height, width: discoverLabel.intrinsicContentSize.width, height: discoverLabel.intrinsicContentSize.height)
    }
}
