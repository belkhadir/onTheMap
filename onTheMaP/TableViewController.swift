//
//  TableViewController.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 13/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class TableViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.leftBarButtonItem = UIBarButtonItem (
            title: "Logout",
            style: .Plain,
            target: self,
            action: "logout")

    }

    @IBAction func add(sender: AnyObject) {
        if sharedNewStudent.sharedInstance().new {
            managedPresentViewController(.addNewStudent)
        }else {
            managedPresentViewController(.addNewLocation)
        }
    }
    func logout() {
        OTMClient.sharedInstance().deleteSession(){
            (success, messageError) in
            if !success {
                self.alertManager("Faild", buttonTitle: "ok", message: "the logout faild", typeAction: .waring)
            }else {
                self.managedPresentViewController(.mainLogin)
            }
        }
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        showStudent()
        
    }
    func showStudent(){
        OTMClient.sharedInstance().getStudentLocation(){ (success, students, errorString) in
            if success {
                //self.studentInformation = students!
                ShareStudent.sharedInstance().student = students!
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView!.reloadData()
                }
            }else {
                self.alertManager("faild", buttonTitle: "try", message: "the loading failed", typeAction: .present(.managerView))
            }
        }
    }
    
    @IBAction func reload(sender: UIBarButtonItem) {
        if isConnectedToNetwork(){
            showStudent()
        }else {
            alertManager("Connection", buttonTitle: "Try", message: "probleme with connection", typeAction: .waring)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShareStudent.sharedInstance().student.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellReuseIdentifier: String = "row"
        let student = ShareStudent.sharedInstance().student[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        cell.textLabel!.text = "Name: \(student.FirstName) " 
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = ShareStudent.sharedInstance().student[indexPath.row]
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: student.MediaURL)!)
    }
    
}

