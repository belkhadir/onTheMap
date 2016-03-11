//
//  sharedStudent.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 26/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ShareStudent {
    
    var student = [StudentInformation]()
    
    
    class func sharedInstance() -> ShareStudent {
        struct Singleton {
            static var sharedInstance = ShareStudent()
        }
        return Singleton.sharedInstance
    }
}

class sharedUpdateStudent {
    var student: StudentInformation?
    
    class func sharedInstance() -> sharedUpdateStudent {
        struct Singleton {
            static var sharedInstance = sharedUpdateStudent()
        }
        return Singleton.sharedInstance
    }
}

class sharedNewStudent {
    
    var ObjectId: String?
    var UniqueKey: String?
    var FirstName: String?
    var LastName: String?
    var MapString: String?
    var MediaURL: String?
    var Latitude: Double?
    var Longitude: Double?
    var placeRemark: CLPlacemark?
    
    var new: Bool = true

    
    class func sharedInstance() -> sharedNewStudent{
        struct Singleton {
            static var sharedInstance = sharedNewStudent()
        }
        return Singleton.sharedInstance
    }
    
}

