//
//  LaunchScreenViewController.swift
//  IMOVE3
//
//  Created by Fhict on 08/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseAuth

class LaunchScreenViewController: UIViewController {

    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadNextView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LoadNextView() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarController") as! TabBarViewController
                let navController = UINavigationController(rootViewController: VC1)
                self.present(navController, animated:true, completion: nil)
                
                
            } else {
                
                let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "Challenge") as! LoginViewController
                self.present(VC1, animated:true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
