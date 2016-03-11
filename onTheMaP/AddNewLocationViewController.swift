//
//  AddNewLocationViewController.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 21/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit
import MapKit

class AddNewLocationViewController: UIViewController , MKMapViewDelegate{
    
    @IBOutlet weak var mediaURL: UITextField!
    @IBOutlet weak var mapViewController: MKMapView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var tapRecognizer: UITapGestureRecognizer? = nil
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mediaURL.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loader.hidden = true
        locate()
        
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer?.numberOfTapsRequired = 1
        addKeyboardDismissRecognizer()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardDismissRecognizer()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    func mapViewWillStartLoadingMap(mapView: MKMapView) {
        view.alpha = 0.5
        loader.startAnimating()
    }
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        view.alpha = 1.0
        loader.stopAnimating()
        loader.hidden = true
    }
    func addKeyboardDismissRecognizer() {
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        alertManager("error", buttonTitle: "ok", message: "\(error)", typeAction: .waring)
    }
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        alertManager("error", buttonTitle: "ok", message: "\(error)", typeAction: .waring)
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        managedPresentViewController(.managerView)
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
    
    func locate(){
        let span = MKCoordinateSpanMake(1, 1)
        let location = CLLocationCoordinate2D(latitude: sharedNewStudent.sharedInstance().Latitude!, longitude: sharedNewStudent.sharedInstance().Longitude!)
        let mkCoordinateSpan = MKCoordinateRegion(center: location, span: span)
        mapViewController.setRegion(mkCoordinateSpan, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = sharedNewStudent.sharedInstance().placeRemark!.location!.coordinate
        mapViewController.addAnnotations([annotation])
        mapViewController.reloadInputViews()
    }
    
    @IBAction func addLocation(sender: UIButton) {
        
        if isConnectedToNetwork()   {
            if mediaURL.text! == "" {
                alertManager("error", buttonTitle: "try", message: "the url is empty", typeAction: .waring)
                return
            }

            sharedNewStudent.sharedInstance().MediaURL = mediaURL.text!
            sharedNewStudent.sharedInstance().UniqueKey = OTMClient.sharedInstance().userID!
            
            if sharedNewStudent.sharedInstance().new {
                OTMClient.sharedInstance().postNewLocation(){
                    (success, objectId) in
                    if success {
                        print("success posting")
                        sharedNewStudent.sharedInstance().ObjectId = objectId!
                        sharedNewStudent.sharedInstance().new = false
                        self.managedPresentViewController(.managerView)
                    }else{
                        print("faild posting")
                        self.alertManager("faild", buttonTitle: "try", message: "post New Student Faild", typeAction: .waring)
                    }
                    
                }
            }else {
                OTMClient.sharedInstance().updateData(){
                        (success, error) in
                        if !success {
                            self.alertManager("ERROR", buttonTitle: "OK", message: "Cannot update new location", typeAction: .waring)
                        }else{
                            self.managedPresentViewController(.managerView)
                        }
                }
            }
        }else {
           alertManager("connection", buttonTitle: "OK", message: "Could not establish connection", typeAction: .waring)
        }
    }
}


extension AddNewLocationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

