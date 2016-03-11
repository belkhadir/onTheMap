//
//  ConfigureUI.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 09/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit

class containerViewController: UIView {
    
    let borderedUIViewHeight: CGFloat = 100.0
    let borderedUIViewWith: CGFloat = 50.0
    let bordedUIViewCornerRadius: CGFloat = 10.0
    let lightBlur = UIBlurEffect(style: .Light)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        print("1")
        self.themeBordered()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.themeBordered()
    }
    
    func themeBordered() -> Void {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = bordedUIViewCornerRadius
        self.backgroundColor = UIColor.blackColor()
        let lightBlur = UIBlurEffect(style: .Light)
        let lightBlurView = UIVisualEffectView(effect: lightBlur)
        self.bounds = lightBlurView.frame
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
            var sizeThatFits = CGSizeZero
            sizeThatFits.width = borderedUIViewHeight
            sizeThatFits.height = borderedUIViewHeight
            return sizeThatFits
    }
    
    
    
}

//
//extension ViewController {
//    
//    func configureUI() {
//        let blurAmountHeight: CGFloat = self.view.bounds.height / 6
//        let blurAmountVerticalMargin: CGFloat = self.view.bounds.width / 4
//        let blurAmountVertical: CGFloat = view.bounds.width - blurAmountVerticalMargin
//        
//        
//        let containerLogin = CGRectMake(10, 150, blurAmountVertical, blurAmountHeight)
//        let lightBlur = UIBlurEffect(style: .Light)
//        let lightBlurView = UIVisualEffectView(effect: lightBlur)
//        lightBlurView.frame = containerLogin
//        
//        view.addSubview(lightBlurView)
//        
//        let containerLoginCGRect = CGRect(x: 0, y: 0, width: blurAmountVertical, height: blurAmountVertical / 2 )
//        
//        
//        let containerEmail = UITextField(frame: containerLoginCGRect)
//        let containerEmailView = UIView(frame: containerEmail.frame)
//        
//        
//        let containerPassword = UITextField(frame: containerLoginCGRect)
//        let containerPasswordView = UIView(frame: containerPassword.frame)
//        
//        
//        var remainder: CGRect
//        (containerEmailView.frame, remainder) = lightBlurView.bounds.divide(blurAmountHeight, fromEdge: .MaxYEdge)
//        (containerPasswordView.frame, remainder) = remainder.divide(blurAmountHeight, fromEdge: .MaxYEdge)
//        
//        containerEmailView.frame.makeIntegralInPlace()
//        containerEmailView.frame.makeIntegralInPlace()
//        view.addSubview(containerEmailView)
//        view.addSubview(containerPasswordView)
//    }
//    
//    private func blurredEffectView(style: UIBlurEffectStyle) -> UIVisualEffectView {
//        let blurred = UIBlurEffect(style: style)
//        let blurredView  = UIVisualEffectView(effect: blurred)
//        blurredView.layer.masksToBounds = true
//        blurredView.layer.cornerRadius = 10.0
//        return blurredView
//        
//    }
//    
//    private func vibrancyEffectView(forBlurEffectView blurEffectView:UIVisualEffectView) -> UIVisualEffectView {
//        let vibrancy = UIVibrancyEffect(forBlurEffect: blurEffectView.effect as! UIBlurEffect)
//        let vibrancyView = UIVisualEffectView(effect: vibrancy)
//        vibrancyView.frame = blurEffectView.bounds
//        vibrancyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//        return vibrancyView
//    }
//}