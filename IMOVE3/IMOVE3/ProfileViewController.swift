//
//  ProfileViewController.swift
//  IMOVE3
//
//  Created by Fhict on 02/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ProfileViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var LevelLabel: UILabel!
    @IBOutlet weak var PointsLabel: UILabel!
    @IBOutlet weak var UserNameLabel: UILabel!
    
    var ref:DatabaseReference!
    var refHandle:UInt!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        LoadProfile()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Functions
    func LoadProfile()
    {
        let uid = (Auth.auth().currentUser?.uid)!
        ref.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let name = dictionary["name"] as! String
                let level = dictionary["level"] as! Int
                let totalScore = dictionary["totalScore"] as! Int
                let profileImage = dictionary["profileImage"] as? String
                
                var user = User(name: name, profileImage: profileImage!, totalScore: totalScore, level: level)
                
                var image:UIImage!
                if let imageURL = user.profileImage {
                    let url = URL(string: imageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            image = UIImage(data:data!)
                            
                            self.profileImage.image = image
                            self.UserNameLabel.text = user.name
                            self.PointsLabel.text = String(user.totalScore)
                            self.LevelLabel.text = String(user.level)
                            
                            
                        }
                    }).resume()
                }
            }
        }
    }
    
}
