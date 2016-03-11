//
//  OTMConvenience.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 12/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import Foundation

extension OTMClient {
    
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
    
    func getUserID(jsonBody: [String: AnyObject],completionHandler: (success: Bool, userID: String?, errorString: String?) -> Void){
        
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
            if let user = account[OTMClient.JSONResponseKeys.userID] as? String {
                completionHandler(success: true, userID: user, errorString: nil)
            }else{
                completionHandler(success: false, userID: nil, errorString: "no user ID")
            }
        }
        
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
    
    func deleteSession(completionHandler: (success: Bool, errorString: String?) -> Void) {
        
        taskForDeleteMethod(OTMClient.Constans.BaseURLSecureUdacity){
            (jsonResult, error) in
            guard error == nil else {
                completionHandler(success: false, errorString: "\(error)")
                return
            }
            if let _ = jsonResult[OTMClient.JSONResponseKeys.session] as? NSDictionary {
                completionHandler(success: true, errorString: nil)
                return
            }else {
                completionHandler(success: false, errorString: nil)
            }
        }
    }

    func postNewLocation(completionHandler: (success: Bool,objectid: String?) -> Void){
        
        let jsonBody = "{\"uniqueKey\": \"\(sharedNewStudent.sharedInstance().UniqueKey!)\", \"firstName\": \"\(sharedNewStudent.sharedInstance().FirstName!)\", \"lastName\": \"\(sharedNewStudent.sharedInstance().LastName!)\",\"mapString\": \"\(sharedNewStudent.sharedInstance().MapString!)\", \"mediaURL\": \"\(sharedNewStudent.sharedInstance().MediaURL!)\",\"latitude\": \(sharedNewStudent.sharedInstance().Latitude!), \"longitude\": \(sharedNewStudent.sharedInstance().Longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)

        taskForPostMethod(OTMClient.Constans.BaseURLSecure, udacity: false, jsonBody: jsonBody! ){
            (result, error) in
            guard error == nil else {
                completionHandler(success: false, objectid: nil)
                return
            }
            if let result = result[OTMClient.JSONResponseKeys.ObjectId] as? String {
                self.objectID = result
                completionHandler(success: true, objectid: result)
            }else{
                completionHandler(success: false, objectid: nil)
            }
            
        }
        
    }
    func getCurrentUserInfo(completionHandler: (success: Bool,currentStudent: StudentInformation?) -> Void) {
        var url: String? = nil
        postNewLocation(){
            (success, objectid) in
            if success {
                url = OTMClient.Constans.BaseURLSecure + "?where=%7B%22uniqueKey%22%3A%22\(objectid!)%22%7D"
                self.taskForGetMethod(url!, udacity: false){
                    (result, error) in
                    guard error == nil else{
                        completionHandler(success: false, currentStudent: nil)
                        return
                    }
                    if let result = result as? [String: AnyObject] {
                        sharedUpdateStudent.sharedInstance().student = StudentInformation(dictionary: result)
                        let user = StudentInformation(dictionary: result)
                        completionHandler(success: true, currentStudent: user)
                        return
                    }
                }
            }else{
                completionHandler(success: false, currentStudent: nil)
            }
        }
    }
    
    func updateData(completionHandler: (success: Bool, messageError: String?)-> Void ){
        
        let jsonBody = "{\"uniqueKey\": \"\(sharedNewStudent.sharedInstance().UniqueKey!)\", \"firstName\": \"\(sharedNewStudent.sharedInstance().FirstName!)\", \"lastName\": \"\(sharedNewStudent.sharedInstance().LastName!)\",\"mapString\": \"\(sharedNewStudent.sharedInstance().MapString!)\", \"mediaURL\": \"\(sharedNewStudent.sharedInstance().MediaURL!)\",\"latitude\": \(sharedNewStudent.sharedInstance().Latitude!), \"longitude\": \(sharedNewStudent.sharedInstance().Longitude!)}".dataUsingEncoding(NSUTF8StringEncoding)
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/" + "\(OTMClient.sharedInstance().objectID!)"
        
        taskForPUTMethod(urlString, udacity: false, jsonBody: jsonBody! ){
            (result, error)  in
            guard error == nil else {
                completionHandler(success: false, messageError: nil)
                return
            }
            if let _ = result[OTMClient.JSONResponseKeys.UpdatedAt] as? String {
                completionHandler(success: true, messageError: nil)
                return
            }else{
                completionHandler(success: false, messageError: nil)
            }
        }
}
    
    func getStudentLocation(completionHandler: (success: Bool, students: [StudentInformation]?, errorString: String?) -> Void ){
        let url: String = OTMClient.Constans.BaseURLSecure +  "?limit=100&order=-updatedAt"
        
        taskForGetMethod(url,udacity:false){
            (jsonResult, error) in
            guard error == nil else{
                completionHandler(success:false , students: nil, errorString: "\(error)")
                return
            }
            if let data = jsonResult[OTMClient.JSONResponseKeys.result] as? [[String: AnyObject]]  {
                let students = StudentInformation.studentFromResult(data)
                completionHandler(success: true, students: students, errorString: nil)
                return
            }else {
                completionHandler(success: false, students: nil, errorString: nil)
            }
        }
    }
    
   }