//
//  addNewStudent.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 29/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import Foundation
import UIKit

class AddNewStudent: UIViewController {
    
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goToSepTwo(sender: UIButton) {
        if firstName.text! != "" && lastName.text! != "" {
            sharedNewStudent.sharedInstance().FirstName = self.firstName.text!
            sharedNewStudent.sharedInstance().LastName = self.lastName.text!

            managedPresentViewController(.addNewLocation)
        }else {
            alertManager("error", buttonTitle: "OK", message: "the text is empty", typeAction: .waring)
        }
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        managedPresentViewController(.managerView)
    }
}