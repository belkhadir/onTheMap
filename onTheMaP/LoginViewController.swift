//
//  ViewController.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 06/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var debugText: UILabel!
    @IBOutlet weak var containerLoginView: RectView!
    @IBOutlet weak var backgroungImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var facebookLogin: FBSDKLoginButton!

    var blurEffectView: UIVisualEffectView?
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    var provider: LoginProvider? = nil
    

    
    var user : LoginUser {
        get {
            return LoginUser(email: emailTextField.text!, password:  passwordTextField.text!)
        }
    }
    let loginManager = FBSDKLoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up the background
        configUI()
        
        // adding facebook login botton
        facebookLogin.readPermissions = ["public_profile", "email", "user_friends"]
        facebookLogin.delegate = self
        
        view.addSubview(facebookLogin)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        addKeyboardDismissRecognizer()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardDismissRecognizer()
        unsubscribeToKeyboardNotifications()
    }
    
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        blurEffectView?.frame = view.bounds
        
    }

    @IBAction func loginWithUdacity(sender: UIButton) {
        if isConnectedToNetwork() {
            provider = .Udacity(user)
            login(provider!)
        }else {
            alertManager("connection", buttonTitle: "OK", message: "Could not establish connection", typeAction: .waring)
        }
    }
    
    
    @IBAction func loginWithFacebook(sender: AnyObject) {
        if isConnectedToNetwork(){
            provider = .Facebook
            login(provider!)
        }else {
            alertManager("connection", buttonTitle: "OK", message: "Could not establish connection", typeAction: .waring)
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
                emailTextField.text! = ""
                passwordTextField.text! = ""
                debugText.text! = ""
    }
    
}


