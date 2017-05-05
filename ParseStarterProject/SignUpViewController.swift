//
//  SignUpViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Mark Moeller on 3/1/17.
//  Copyright © 2017 Parse. All rights reserved.
// test

import Foundation
import ParseFacebookUtilsV4
import ParseUI
import Parse

class SignUpViewController: PFSignUpViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "feet-1031365.jpg"))
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        signUpView!.insertSubview(backgroundImage, at: 0)
        
        // remove the parse Logo
        let logo = UILabel()
        logo.text = "Hoos Going Poo"
        logo.textColor = UIColor.orange
        logo.font = UIFont(name: "American Typewriter", size: 50)
        logo.shadowColor = UIColor.lightGray
        logo.shadowOffset = CGSize(width: 2, height: 2)
        signUpView?.logo = logo
        
        signUpView?.signUpButton?.setBackgroundImage(nil, for: .normal)
        signUpView?.signUpButton?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        
        // change dismiss button to say 'Already signed up?'
        signUpView?.dismissButton!.setTitle("Already signed up?", for: .normal)
        signUpView?.dismissButton!.setImage(nil, for: .normal)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRect( x: 0,  y: 0,  width: signUpView!.frame.width,  height: signUpView!.frame.height)
        
        // position logo at top with larger frame
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRect(x: logoFrame.origin.x, y: signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, width: signUpView!.frame.width,  height: logoFrame.height)
        
        // re-layout out dismiss button to be below sign
        let dismissButtonFrame = signUpView!.dismissButton!.frame
        signUpView?.dismissButton!.frame = CGRect(x: 0, y: signUpView!.signUpButton!.frame.origin.y + signUpView!.signUpButton!.frame.height + 16.0,  width: signUpView!.frame.width,  height: dismissButtonFrame.height)
    }
    
}
