//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 1/7/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps
import FBSDKLoginKit
import ParseFacebookUtilsV4
import ParseUI


/*
class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton : FBSDKLoginButton = FBSDKLoginButton()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    var signUpMode = false
    var fbLoginSucess = false
    
    
    @IBOutlet weak var loginOrSignUpButton: UIButton!
    @IBOutlet weak var switchButton: UIButton!
    @IBAction func loginButton(_ sender: UIButton!) {
        
        if usernameTextField.text == "" || passwordTextField.text == "" {
            displayAlert(title: "Error in form", message: "Username and Password are required")
        } else {
            if signUpMode {
                if passwordTextField.text != confirmPassword.text {
                    displayAlert(title: "Error in form", message: "Password fields do not match")
                } else {
                    let user = PFUser()
                    user.username = usernameTextField.text
                    user.password = passwordTextField.text
                    user.signUpInBackground(block: { (success, error) in
                        if let error = error {
                            var displayedErrorMessage = "Please try again later"
                            if let parseError = (error as NSError).userInfo["error"] as? String {
                                displayedErrorMessage = parseError
                            }
                        
                        self.displayAlert(title: "Sign Up Failed", message: displayedErrorMessage)
                        }
                        else {
                            self.performSegue(withIdentifier: "toMenuSegue", sender: self)

                            print("Sign Up Successful")
                        }
                    })
                }
                    
                
                
            } else {
                
                // Login mode
                
                PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!, block: { (user, error) in
                    
// spinner?         self.activityIndicator.stopAnimating()
                    
                    UIApplication.shared.endIgnoringInteractionEvents() // UIApplication.shared() is now UIApplication.shared
                    
                    
                    if error != nil {
                        
                        var displayErrorMessage = "Please try again later."
                        
                        let error = error as NSError?
                        
                        if let errorMessage = error?.userInfo["error"] as? String {
                            
                            displayErrorMessage = errorMessage
                            
                        }
                        
                        self.displayAlert(title: "Login Error", message: displayErrorMessage)
                        
                        
                    } else {
                        
                        print("Logged in")
                        
                        self.performSegue(withIdentifier: "toMenuSegue", sender: self)
                        
                    }
                    
                    
                })
            }
        }
       
            
        
    }
    
    @IBAction func switchButton(_ sender: UIButton!) {
        
        if signUpMode {
            loginOrSignUpButton.setTitle("Log In", for: [])
            switchButton.setTitle("Switch to Sign Up", for: [])
            signUpMode = false
            confirmPassword.isHidden = true
            
        }
        else {
            loginOrSignUpButton.setTitle("Sign Up", for: [])
            switchButton.setTitle("Switch to Log In", for: [])
            signUpMode = true
            confirmPassword.isHidden = false
        }
            
    
        
    }
    


    
    
    func displayAlert(title: String, message: String){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     confirmPassword.isHidden = true
        
        FBSDKLoginManager().logOut()

        
        if (FBSDKAccessToken.current() != nil)
        {
            
           performSegue(withIdentifier: "toMenuSegue", sender: self)
            
            print("Facebook Logged In")
            
        }
        else
        {
            
            
            loginButton.center = self.view.center
            
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            
            loginButton.delegate = self
            
            self.view.addSubview(loginButton)
        }

        // Do any additional setup after loading the view.
    }
    

    
    /////FACEBOOK
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        
        if error != nil
        {
            print("error on didCompleteWith")
            print(error)
            
        }
        else if result.isCancelled {
            
            print("User cancelled login")
            
        }
        else {
            let permissions = ["public_profile", "email", "user_friends"]
            


            

            if result.grantedPermissions.contains("email")
            {
                
                if let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"]) {
                    
                    graphRequest.start(completionHandler: { (connection, result, error) in
                        
                        if error != nil {
                            
                            print(error)
                            
                        } else {
                            
                            self.fbLoginSucess = true
                            self.performSegue(withIdentifier: "toMenuSegue", sender: self)
                            
                            if let userDetails = result as? [String: String] {
                            
                            let userId:String = userDetails["id"] as! String!
                            let userFirstName:String? = (userDetails["first_name"] as? String?)!
                            let userLastName:String? = (userDetails["last_name"] as? String?)!
                            let userEmail:String? = (userDetails["email"] as? String?)!
                            
                            
                            print("\(userEmail)")
                            
                            let myUser = PFUser()
                            
                            // Save first name
                            if(userFirstName != nil)
                            {
                                myUser.setObject(userFirstName!, forKey: "first_name")
                                
                            }
                            
                            //Save last name
                            if(userLastName != nil)
                            {
                                myUser.setObject(userLastName!, forKey: "last_name")
                            }
                            
                            // Save email address
                            if(userEmail != nil)
                            {
                                myUser.setObject(userEmail!, forKey: "email")
                            }
                            
//                            DispatchQueue.global(DispatchQueue.GlobalQueuePriority.default, 0).asynchronously() {
                                
                                // Get Facebook profile picture
                                var userProfile = "https://graph.facebook.com/" + userId + "/picture?type=large"
                                
                                let profilePictureUrl = NSURL(string: userProfile)
                                
                                let profilePictureData = NSData(contentsOf: profilePictureUrl! as URL)
                                
                                if(profilePictureData != nil)
                                {
                                    let profileFileObject = PFFile(data:profilePictureData! as Data)
                                    myUser.setObject(profileFileObject, forKey: "profile_picture")
                                }
                                
                                
                                myUser.signUpInBackground(block: { (success, error) in
                                    
                                    if(success)
                                    {
                                        print("User details are now updated")
                                    }
                                    
                                })
                            }
                            
                            }
                            
                        })
                            
//                            if let userDetails = result as? [String: String] {

                                
//                                print(userDetails["email"])
                                
 //                           }
                            
                    
                        
                
                
                
                        
            }
        }
 
            }
 
        }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Logged out")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
 
*/

/*
//This works
class LoginViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.current() == nil) {
            let loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            loginViewController.fields = [.usernameAndPassword, .logInButton, .passwordForgotten, .signUpButton, .facebook, .twitter]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            self.present(loginViewController, animated: false, completion: nil)
        } else {
     //       presentLoggedInAlert()
            self.performSegue(withIdentifier: "toMenuSegue", sender: AnyObject.self)
        }
    }
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        presentLoggedInAlert()
        self.performSegue(withIdentifier: "toMenuSegue", sender: AnyObject.self)
    }
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        presentLoggedInAlert()
        self.performSegue(withIdentifier: "toMenuSegue", sender: AnyObject.self)
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Vay.K", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
 */

class LoginViewController: PFLogInViewController {
    
    var backgroundImage : UIImageView!
    var viewsToAnimate = [UIView]()
    var viewsFinalYPosition : [CGFloat]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpController = SignUpViewController()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "feet-1031365.jpg"))
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.logInView!.insertSubview(backgroundImage, at: 0)
        
        //Remove the Parse logo
        let logo = UILabel()
        logo.text = "Hoos Going Poo"
        logo.textColor = UIColor.orange
        logo.font = UIFont(name: "Pacifico", size: 50)
        logo.shadowColor = UIColor.lightGray
        logo.shadowOffset = CGSize(width: 2, height: 2)
        logInView?.logo = logo
        
        
        
        logInView?.logInButton?.setBackgroundImage(nil, for: .normal)
        logInView?.logInButton?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.white, for: .normal)
        logInView?.usernameField?.backgroundColor = UIColor.clear
        logInView?.passwordField?.backgroundColor = UIColor.clear
        
        // make the buttons classier
        customizeButton(button: logInView?.facebookButton!)
        customizeButton(button: logInView?.twitterButton!)
        customizeButton(button: logInView?.signUpButton!)
        
        // create an array of all the views we want to animate in when we launch
        // the screen
        
        viewsToAnimate.append((logInView!.usernameField)!)
        viewsToAnimate.append((logInView!.passwordField)!)
        viewsToAnimate.append((logInView!.logInButton)!)
        viewsToAnimate.append((logInView!.passwordForgottenButton)!)
        viewsToAnimate.append((logInView!.facebookButton)!)
        viewsToAnimate.append((logInView!.twitterButton)!)
        viewsToAnimate.append((logInView!.signUpButton)!)
        viewsToAnimate.append((logInView!.logo)!)
        
       


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.logInView!.frame.width, height: self.logInView!.frame.height)
        
        // position logo at top with larger frame
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRect(x: logoFrame.origin.x, y: logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, width: logInView!.frame.width,  height: logoFrame.height)
        
        // We to position all the views off the bottom of the screen
        // and then make them rise back to where they should be
        // so we track their final position in an array
        // but change their frame so they are shifted downwards off the screen
        viewsFinalYPosition = [CGFloat]();
        for viewToAnimate in viewsToAnimate {
            let currentFrame = viewToAnimate.frame

            viewsFinalYPosition.append(currentFrame.origin.y - 150)
            viewToAnimate.frame = CGRect(x: currentFrame.origin.x, y: self.view.frame.height + currentFrame.origin.y, width: currentFrame.width, height: currentFrame.height)

        }
    }
    
        
        
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        var i = 0
            
            // Now we'll animate all our views back into view
            // and, using the final position we stored, we'll
            // reset them to where they should be

            if viewsFinalYPosition.count == self.viewsToAnimate.count {
                UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear,  animations: { () -> Void in
                    for viewToAnimate in self.viewsToAnimate {
                        let currentFrame = viewToAnimate.frame
                        viewToAnimate.frame = CGRect(x: currentFrame.origin.x, y: self.viewsFinalYPosition[i], width: currentFrame.width, height: currentFrame.height)
                        i = i + 1
                    }
                }, completion: nil)
            }
        }
    
    
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, for: .normal)
        button.backgroundColor = UIColor.clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
    }
    
}
 
