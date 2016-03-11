//
//  TextFieldView.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 17/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit


@IBDesignable class RectView : UIView {
    
    
    @IBInspectable var usableArea:CGRect = CGRect(x: 0, y: 0, width: 100, height: 100)
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    //@IBInspectable var blurStyle: UIBlurEffectStyle = .ExtraLight {
    //        didSet {
    //            let newEffect = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    //            effectView.removeFromSuperview()
    //            effectView = newEffect
    //            insertSubview(effectView, belowSubview: wrappedView)
    //
    //        }
    //    }
    
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
    
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    
}
//
//class RectView: UIView {

//    
//    private var effectView: UIVisualEffectView
//    private var wrappedView: UIView
//    
//    init(view: UIView) {
//        wrappedView = view
//        effectView = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
//        super.init(frame: CGRectZero)
//        
//        addSubview(effectView)
//        addSubview(wrappedView)
//    }
//
//}
