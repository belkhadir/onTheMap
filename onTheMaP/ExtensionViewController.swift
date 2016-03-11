//
//  AlertViewController.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 20/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit
import  SystemConfiguration

extension UIViewController {
    
    public enum PresntViewController:String {
        case  mainLogin = "mainLogin"
        case addNewLocation = "AddNewLocation"
        case managerView = "ManagerNavigationController"
        case addNewStudent = "addNewStudent"
        case addNewStudentMap = "addNewStudentMap"
    }
    
    
    
    public enum AlertCase {
        case dissmiss
        case present(PresntViewController)
        case waring
    }
    
    func alertManager(title: String?,buttonTitle: String? ,message: String?, typeAction: AlertCase){
        let alert = UIAlertController(title: title!, message: message!, preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: buttonTitle!, style: UIAlertActionStyle.Default, handler: {action in
            switch(typeAction){
            case .dissmiss:
                self.dismissViewControllerAnimated(true, completion: nil)
            case .present(let value):
                self.managedPresentViewController(value)
            case .waring :
                return
            }
        })
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func managedPresentViewController(storyboardTarget: PresntViewController){
        switch(storyboardTarget){
        case  .mainLogin:
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier(PresntViewController.mainLogin.rawValue)
                self.presentViewController(controller, animated: true, completion: nil)
            })
        case .addNewLocation:
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier(PresntViewController.addNewLocation.rawValue)
                self.presentViewController(controller, animated: true, completion: nil)
            })
        case .managerView:
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier(PresntViewController.managerView.rawValue)
                self.presentViewController(controller, animated: true, completion: nil)
            })
        case .addNewStudent :
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier(PresntViewController.addNewStudent.rawValue)
                self.presentViewController(controller, animated: true, completion: nil)
            })
        case  .addNewStudentMap :
            dispatch_async(dispatch_get_main_queue(), {
                let controller = self.storyboard!.instantiateViewControllerWithIdentifier(PresntViewController.addNewStudentMap.rawValue)
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}
