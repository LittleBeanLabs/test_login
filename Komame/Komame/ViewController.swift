//
//  ViewController.swift
//  Komame
//
//  Created by Paul de Lange on 3/07/2015.
//  Copyright © 2015 Little Bean Labs. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate  {
    
    var logged_in : Bool = FBSDKAccessToken.currentAccessToken() != nil //Bug, doesn't seem to work... :(
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var emailVerifiedField: UILabel!
    @IBOutlet weak var subscriptionExpiryField: UILabel!
    
    @IBOutlet var loggedOutUIElements: [UIView]!
    @IBOutlet var loggedInUIElements: [UIView]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.facebookButton.readPermissions = ["public_profile", "email"]
        
        // Do any additional setup after loading the view, typically from a nib.
        self.loginButton.enabled = !logged_in;
        self.logoutButton.enabled = logged_in;
        
        toggleUIState(logged_in)
    }
    
    @IBAction func forgotPushed(sender: AnyObject) {
        //Sakai-san Go!
    }
    
    @IBAction func loginPushed(sender: AnyObject) {
        //Sakai-san Go!
        logged_in = true
        toggleUIState(logged_in)
    }
    
    @IBAction func logoutPushed(sender: AnyObject) {
        //Sakai-san Go!
        logged_in = false
        toggleUIState(logged_in)
    }
    
    func toggleUIState(isLoggedIn: Bool) {
        UIView.animateWithDuration(0.3) { () -> Void in
            for element: UIView in self.loggedInUIElements {
                element.alpha = isLoggedIn ? 1 : 0.5;
                if let control = element as? UIControl {
                    control.enabled = isLoggedIn;
                }
            }
            
            for element: UIView in self.loggedOutUIElements {
                element.alpha = isLoggedIn ? 0.5 : 1;
                if let control = element as? UIControl {
                    control.enabled = !isLoggedIn;
                }
            }
        }
    }
    
    func isValidEmail(candidate: String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(candidate)
    }
    
    func isValidPassword(password: String) -> Bool {
        return count(password) > 5
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        self.loginButton.enabled = false;
        
        let beforeText = NSString(string: textField.text!)
        
        if textField == self.emailField {
            self.passwordField.text = ""
            if isValidEmail(beforeText.stringByReplacingCharactersInRange(range, withString: string)) {
                textField.textColor = UIColor.blackColor()
            } else {
                textField.textColor = UIColor.redColor()
            }
            
        } else if textField == self.passwordField {
            if isValidPassword(beforeText.stringByReplacingCharactersInRange(range, withString: string)) {
                textField.textColor = UIColor.blackColor()
                
                self.loginButton.enabled = isValidEmail(self.emailField.text!)
            } else {
                textField.textColor = UIColor.redColor()
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.emailField {
            self.passwordField.becomeFirstResponder()
        }
        
        return true
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil {
            
        } else if result.isCancelled {
            
        } else {
            if result.grantedPermissions.contains("email") {
                let request : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                request.startWithCompletionHandler({ (connection, result, error) -> Void in
                    if error != nil {
                        println("Error fetching email: \(error)");
                    } else {
                        let email : NSString = result.valueForKey("email") as! NSString
                        let fbid : NSString = FBSDKAccessToken.currentAccessToken().userID as NSString
                        
                        println("\(fbid)'s email is: \(email)");
                        
                        //Sakai-san Go!
                        
                        self.logged_in  = true
                    }
                    
                    self.toggleUIState(self.logged_in)
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.logged_in = false
        
        toggleUIState(self.logged_in)
    }
}

