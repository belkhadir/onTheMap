//
//  OTMConstants.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 09/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

extension OTMClient {
    
    struct Constans {

        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let BaseURLSecure = "https://api.parse.com/1/classes/StudentLocation"
        static let BaseURLSecureUdacity = "https://www.udacity.com/api/session"
        static let UdacityFacebookAppID = "365362206864879"
        static let UdacityFacebookURLSchemeSuffix = "onthemap"
    }
    
    struct ForHTTPHeaderField {
       static let Accept = "Accept"
       static let ContentType = "Content-Type"
       static let XXSRFTOKEN = "X-XSRF-TOKEN"
    }

    
    struct  JSONResponseKeys {
        //Udacity
        
        static let session = "session"
        static let sessionID = "id"
        static let account = "account"
        static let userID = "key"
        
        
        
        // parse
        static let result = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"
    }
}