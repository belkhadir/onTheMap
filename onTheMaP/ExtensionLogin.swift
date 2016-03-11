//
//  File.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 06/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


extension LoginViewController {
    
    func configUI() {
        backgroungImageView.image = UIImage(named: "temple")
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView?.frame = view.bounds
        backgroungImageView.addSubview(blurEffectView!)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        
    }
    func shakeItOf(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.02
        animation.repeatCount = 30
        animation.autoreverses  = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(view.center.x - 4, view.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(view.center.x + 4, view.center.y))
        view.layer.addAnimation(animation, forKey: "position")
    }
    
    
}
extension LoginViewController {
    
    enum LoginProvider {
        case Facebook
        case Udacity(LoginUser)
    }
    
    func login(type: LoginProvider){
        switch type {
        case let .Udacity(user) where user.isValid():
            OTMClient.sharedInstance().udacitySessiont(user){
                (succsess, messageError) in
                if succsess {
                    self.managedPresentViewController(.managerView)
                }else {
                    dispatch_async(dispatch_get_main_queue(), {self.shakeItOf()
                        self.alertManager("error ", buttonTitle: "OK", message: "error with Email or password ", typeAction: .waring)
                        self.debugText.hidden = false
                        self.debugText.text! = "error with Email or password "
                    })
                    
                    
                }
            }
        case let .Udacity(user) where !user.isValid():
            alertManager("error ", buttonTitle: "OK", message: "error with Email or password ", typeAction: .waring)
        
        case .Facebook:
            return
        default:
            alertManager("error ", buttonTitle: "try", message: "error with Email or password ", typeAction: .waring)
   
        }
    }

    
}


extension LoginViewController :FBSDKLoginButtonDelegate{
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if error == nil
        {
            managedPresentViewController(.managerView)
        }else {
            alertManager("error", buttonTitle: "OK", message: "\(error.localizedDescription)", typeAction: .waring)
        }
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LoginViewController {
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
}
