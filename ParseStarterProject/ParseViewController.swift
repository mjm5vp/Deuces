//
//  ParseViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 2/27/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import Foundation
import ParseUI
import Parse
import ParseTwitterUtils
import ParseFacebookUtilsV4

class ParseViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

        
        if (PFUser.current() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = [.usernameAndPassword, .logInButton, .passwordForgotten, .signUpButton, .facebook, .twitter]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            self.present(loginViewController, animated: false, completion: nil)
            
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
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
