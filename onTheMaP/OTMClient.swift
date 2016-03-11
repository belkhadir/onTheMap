//
//  OTMClient.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 09/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import Foundation


class OTMClient: NSObject {
    
    var session: NSURLSession
    
    var sessionID: String? = nil    
    var userID: String? = nil
    var objectID: String? = nil
    
    var student: StudentInformation? = nil
    //Mark: Initializers
    override init() {
        session = NSURLSession.sharedSession()
        super.init()
    }
    
    func taskForGetMethod(url: String,udacity: Bool,completionHandeler: (result:AnyObject!, error: ErrorType?) -> Void ) ->NSURLSessionDataTask {
        //var mutableParameters = parameters
        //Don't Forget set the api beafore start making a request
        let url = NSURL(string: url)!
        let request = NSMutableURLRequest(URL: url)
        request.addValue(OTMClient.Constans.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.Constans.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let task = session.dataTaskWithRequest(request) { (data , response , error) in
            guard (error == nil) else{
                print("There was error with the request")
                return
            }
            
            OTMClient.statusCodeWithCompletionHandler(response!){
                success in
                if !success {
                    return
                }
            }
            
            
            guard let data = data else{
                print("no data was returned by the server")
                return
            }
            OTMClient.parseJSONWithCompletionHandler(data,udacity: udacity ,completionHandler: completionHandeler)
        }
        task.resume()
        return task
    }
    func taskForPostMethod(url: String ,udacity: Bool,jsonBody: AnyObject ,completionHandeler: (result:AnyObject!, error: ErrorType?) -> Void ) ->NSURLSessionDataTask {
        //var mutableParameters = parameters
        //Don't Forget set the api beafore start making a request
        let urlString: String = url
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        if udacity {
            request.addValue("application/json", forHTTPHeaderField: OTMClient.ForHTTPHeaderField.Accept)
            request.addValue("application/json", forHTTPHeaderField: OTMClient.ForHTTPHeaderField.ContentType)
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }else {
            request.addValue(OTMClient.Constans.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(OTMClient.Constans.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: OTMClient.ForHTTPHeaderField.ContentType)


            //request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
            request.HTTPBody = jsonBody as? NSData
        }
        
        
        let task = session.dataTaskWithRequest(request) { (data , response , error) in
            guard (error == nil) else{
                print("There was error with the request")
                return
            }
            OTMClient.statusCodeWithCompletionHandler(response!){
                success in
                if !success {
                    return
                }
            }
            
            guard let data = data else{
                print("no data was returned by the server")
                return
            }
            OTMClient.parseJSONWithCompletionHandler(data,udacity: udacity ,completionHandler: completionHandeler)
        }
        task.resume()
        return task
    }
    
    func taskForDeleteMethod(url: String,completionHandeler: (result: AnyObject!,error: NSError?) -> Void)->NSURLSessionDataTask {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies as [NSHTTPCookie]! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: OTMClient.ForHTTPHeaderField.XXSRFTOKEN)
        }
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard error == nil else{
                print("error occur")
                return
            }
            OTMClient.statusCodeWithCompletionHandler(response!){
                success in
                if !success {
                    return
                }
            }
            guard let data = data else{
                print("no data returned ")
                return
            }
            OTMClient.parseJSONWithCompletionHandler(data,udacity: true ,completionHandler: completionHandeler)
        }
        task.resume()
        return task
    }
    
    func taskForPUTMethod(url: String ,udacity: Bool,jsonBody: AnyObject ,completionHandeler: (result:AnyObject!, error: ErrorType?) -> Void ) ->NSURLSessionDataTask {
        
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url!)
        
        request.HTTPMethod = "PUT"
        request.addValue(OTMClient.Constans.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(OTMClient.Constans.RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        request.HTTPBody = jsonBody as? NSData
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            guard error == nil else{
                print(error)
                return
            }
            OTMClient.statusCodeWithCompletionHandler(response!){
                success in
                if !success {
                    return
                }
            }
            
            guard let data = data else{
                print("no data was returned by the server")
                return
            }
            OTMClient.parseJSONWithCompletionHandler(data,udacity: udacity ,completionHandler: completionHandeler)
        }
        
        task.resume()
        return task
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
    
    class func parseJSONWithCompletionHandler(data: NSData,udacity: Bool ,completionHandler: (result: AnyObject!,error: NSError?) -> Void ){
        
        var parsedResult: AnyObject!
        do {
            if udacity{
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
                parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments) as? [String: AnyObject]
            } else{
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject]
            }
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandler(result: parsedResult, error: nil)
    }
    
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    
    class func sharedInstance() -> OTMClient {
        struct Singleton {
            static var sharedInstance = OTMClient()
        }
        return Singleton.sharedInstance
    }
    
}