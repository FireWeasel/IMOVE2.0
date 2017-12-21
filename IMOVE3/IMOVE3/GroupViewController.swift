//
//  GroupViewController.swift
//  IMOVE3
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    var challenge:ChallengeAnnotation!
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseButton.layer.cornerRadius = 10
        exerciseButton.clipsToBounds = true
        self.nameLabel.text = challenge.name!
        self.descLabel.text = challenge.desc!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func Login(_ sender: Any) {
        if(nameTextfield.text == "admin" && passwordTextfield.text == "admin")
        {
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "InstructorLogIn")
            UIApplication.topViewController()?.present(nextViewController, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Wrong Log In", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}


