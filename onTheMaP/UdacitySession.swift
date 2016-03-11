//
//  UdacitySession.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 22/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import Foundation

class UdacitySession: NSObject {
    
    var userFirstName: String? = nil
    var userLastName: String? = nil
    
    var session: NSURLSession
    var completionHandler : ((success: Bool, errorString: String?) -> Void)? = nil
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    
    class func sharedInstance() -> UdacitySession {
        struct Singleton {
            static var sharedInstance = UdacitySession()
        }
        return Singleton.sharedInstance
    }
    
    func udacitySessiont(user: LoginUser, completionHandler: (success: Bool, messageError: String?)-> Void ){
        
        let jsonBodyUdacity : [String:AnyObject] = [
            "udacity": [
                "username": user.email,
                "password": user.password
            ]
        ]
        self.getUserID(jsonBodyUdacity){
            (success, userID,errorString) in
            if success {
                self.userID = userID
                completionHandler(success: true, messageError: nil)
            }else{
                completionHandler(success: false, messageError: "enabled to reach")
            }
            
        }
        
    }
    
    func getUserID(jsonBody: [String: AnyObject],completionHandler: (success: Bool, userID: Int?, errorString: String?) -> Void){
        
        taskForPostMethod(OTMClient.Constans.BaseURLSecureUdacity,udacity: true,jsonBody: jsonBody){
            (jsonResult, error) in
            guard error==nil else{
                completionHandler(success: false, userID: nil, errorString: "error occur \(error)")
                return
            }
            guard let account = jsonResult[OTMClient.JSONResponseKeys.account] as? [String:AnyObject] else {
                completionHandler(success: false, userID: nil, errorString: "no such key")
                return
            }
            if let user = account[OTMClient.JSONResponseKeys.userID] {
                completionHandler(success: true, userID: user as? Int, errorString: nil)
            }else{
                completionHandler(success: false, userID: nil, errorString: "no user ID")
            }
        }
        
    }
    func getObjectID(){
        
    }
    
    func getSessionId(jsonBody: [String: AnyObject],completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void){
        
        taskForPostMethod(OTMClient.Constans.BaseURLSecureUdacity,udacity: true,jsonBody: jsonBody){
            (jsonResult, error) in
            guard error==nil else{
                completionHandler(success: false, sessionID: nil, errorString: "error occur \(error)")
                return
            }
            guard let account = jsonResult[OTMClient.JSONResponseKeys.account] as? [String:AnyObject] else {
                completionHandler(success: false, sessionID: nil, errorString: "no such key")
                return
            }
            if let sessionID = account[OTMClient.JSONResponseKeys.sessionID] {
                completionHandler(success: true, sessionID: sessionID as? String, errorString: nil)
            }else{
                completionHandler(success: false, sessionID: nil, errorString: "no user ID")
            }
        }
        
    }


    class func statusCodeWithCompletionHandler(response: AnyObject, completionHandler: (success: Bool) -> Void){
        guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
            if let response = response as? NSHTTPURLResponse {
                print("Your request returned an invalid response! Status code: \(response.statusCode)!")
            } else {
                print("Your request returned an invalid response!")
            }
            completionHandler(success: false)
            return
        }
        completionHandler(success: true)
    }
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!,error: NSError?) -> Void ){
        
        var parsedResult: AnyObject!
        do {
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? [String: AnyObject]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }

    
}
