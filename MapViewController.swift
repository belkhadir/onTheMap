//
//  MapViewController.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 10/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//



import UIKit
import FBSDKLoginKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    
    @IBOutlet weak var mapViewController: MKMapView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        pin()
    }
    
    func pin() {
        OTMClient.sharedInstance().getStudentLocation(){ (success, students, errorString) in
            if success {
                ShareStudent.sharedInstance().student = students!
                dispatch_async(dispatch_get_main_queue(), {
                    var annotations = [MKPointAnnotation]()
                    
                    // The "locations" array is loaded with the sample data below. We are using the dictionaries
                    // to create map annotations. This would be more stylish if the dictionaries were being
                    // used to create custom structs. Perhaps StudentLocation structs.
                    
                    for dictionary in ShareStudent.sharedInstance().student {
                        // Notice that the float values are being used to create CLLocationDegree values.
                        // This is a version of the Double type.
                        let lat = CLLocationDegrees(dictionary.Latitude )
                        let long = CLLocationDegrees(dictionary.Longitude)
                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = dictionary.FirstName
                        let last = dictionary.LastName
                        let mediaURL = dictionary.MediaURL
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                    }
                    
                    // When the array is complete, we add the annotations to the map.
                    self.mapViewController.addAnnotations(annotations)
                })}
        }
        self.mapViewController.reloadInputViews()

    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        if isConnectedToNetwork(){
            pin()
        }else {
            alertManager("Connection", buttonTitle: "Try", message: "probleme with connection", typeAction: .waring)
        }
    }
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        alertManager("Faild", buttonTitle: "ok", message: "cannot load Data", typeAction: .waring)
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(NSURL(string: toOpen)!)
            }
        }
    }
    
    @IBAction func logout() {
        OTMClient.sharedInstance().deleteSession(){
            (success, messageError) in
                if !success {
                    self.alertManager("faild", buttonTitle: "try", message: "the log out faild. Try again", typeAction: .waring)
                }else {
                    self.managedPresentViewController(.mainLogin)
            }
        }
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }

    @IBAction func add(sender: UIBarButtonItem) {
        if sharedNewStudent.sharedInstance().new {
            managedPresentViewController(.addNewStudent)
        }else {
            managedPresentViewController(.addNewLocation)
        }
    }

    
}
