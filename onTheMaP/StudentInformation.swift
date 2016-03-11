//
//  StudentInformation.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 12/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import Foundation

struct StudentInformation {
    var ObjectId: String
    var UniqueKey: String
    var FirstName: String
    var LastName: String
    var MapString: String
    var MediaURL: String
    var Latitude: Double
    var Longitude: Double
    var CreatedAt: String
    var UpdatedAt: String
    //let ACL: String
    
    init(dictionary: [String: AnyObject]){
        self.ObjectId = dictionary[OTMClient.JSONResponseKeys.ObjectId] as! String
        self.UniqueKey = dictionary[OTMClient.JSONResponseKeys.UniqueKey] as! String
        self.FirstName = dictionary[OTMClient.JSONResponseKeys.FirstName] as! String
        self.LastName = dictionary[OTMClient.JSONResponseKeys.LastName] as! String
        self.MapString = dictionary[OTMClient.JSONResponseKeys.MapString] as! String
        self.MediaURL = dictionary[OTMClient.JSONResponseKeys.MediaURL] as! String
        self.Latitude = dictionary[OTMClient.JSONResponseKeys.Latitude] as! Double
        self.Longitude = dictionary[OTMClient.JSONResponseKeys.Longitude] as! Double
        self.CreatedAt = dictionary[OTMClient.JSONResponseKeys.CreatedAt] as! String
        self.UpdatedAt = dictionary[OTMClient.JSONResponseKeys.UpdatedAt] as! String
        //self.ACL = dictionary[OTMClient.JSONResponseKeys.ACL] as! String
    }
}

extension StudentInformation {
    // helper function :Given an array of dictionaries, convert them to an array of StudentInformation objects
    static func studentFromResult(result: [[String: AnyObject]]) -> [StudentInformation] {
        var students = [StudentInformation]()
        for student in result {
            students.append(StudentInformation(dictionary: student))
        }
        return students
        
    }
    
    
}