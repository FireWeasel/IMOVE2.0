//
//  LoginViewController.swift
//  IMOVE3
//
//  Created by Fhict on 07/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
    var ref:DatabaseReference!
    var refHandler:UInt!
    
    @IBOutlet weak var passTb: UITextField!
    @IBOutlet weak var nameTb: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func Hide(_ sender: Any) {
        view.endEditing(true)
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        
        let email = nameTb.text! + "@email.com"
        let password = passTb.text
        
        Auth.auth().signIn(withEmail: email, password: password!) { (user, error) in
            
            if error == nil {
                
                print("You have successfully logged in")
                
                let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
                self.present(VC1, animated:true, completion: nil)
                
            } else {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        
    }
    
}
