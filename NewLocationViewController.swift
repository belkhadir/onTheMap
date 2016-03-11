//
//  AddNewStudentViewController.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 16/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit
import MapKit

class NewLocationViewController : UIViewController {
    

 
    @IBOutlet weak var locationString: UITextField!
    @IBOutlet weak var background: UIImageView!
    
    var location: CLLocationCoordinate2D? = nil
    var placemark: CLPlacemark? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(sender: AnyObject) {
        managedPresentViewController(.managerView)
    }

    @IBAction func addNewLocation(sender: UIButton) {
        if isConnectedToNetwork() {
            //print("success network")
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(locationString.text!){
                (placemarks , error ) -> Void in
                guard error == nil else{
                    self.alertManager("faild", buttonTitle: "OK", message: "error with server", typeAction: .waring)
                    return
                }
                if let placemark = placemarks?[0] {
                    sharedNewStudent.sharedInstance().MapString = self.locationString.text!
                    sharedNewStudent.sharedInstance().Latitude = placemark.location!.coordinate.latitude
                    sharedNewStudent.sharedInstance().Longitude = placemark.location!.coordinate.longitude
                    sharedNewStudent.sharedInstance().placeRemark = placemark
                    self.managedPresentViewController(.addNewStudentMap)
                }else {
                    self.alertManager("faild", buttonTitle: "try", message: "the location don't exist", typeAction: .waring)
                }
            }
        }else {
            alertManager("connection", buttonTitle: "OK", message: "Could not establish connection", typeAction: .waring)
        }
    }
}
