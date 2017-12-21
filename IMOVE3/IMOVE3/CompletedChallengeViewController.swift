//
//  CompletedChallengeViewController.swift
//  IMOVE_Test
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CompletedChallengeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nrLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var count : Int!
    var score : Int!
    var challenge: ChallengeAnnotation!
    var leaderboardList = [LeaderBoard]()
    var ref:DatabaseReference!
    var refHandle:UInt!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        tableView.delegate = self
        tableView.dataSource = self
        self.nameLabel.text = challenge.name
        self.nrLabel.text = String(self.count)
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hey")
        return leaderboardList.count
        
    }
    
    @IBAction func completeChallengeButton(_ sender: Any) {
        LoadProfile()
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        self.present(VC1, animated:true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for:indexPath)
        print(leaderboardList)
        cell.textLabel?.text = leaderboardList[indexPath.row].name
        return cell
    }
    

    func LoadProfile()
    {
        let uid = (Auth.auth().currentUser?.uid)!
        ref.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let name = dictionary["name"] as! String
                let level = dictionary["level"] as! Int
                var totalScore = dictionary["totalScore"] as! Int
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
                            self.score = self.count * 10
                            
                            //update object in database for leaderboars
                            let leaderboardHandle = self.ref.child("Leaderboards").child(self.challenge.name).child(uid)
                            var leaderboardValue = [
                                "name": name,
                                "points": self.score
                                ] as [String : Any]
                            leaderboardHandle.updateChildValues(leaderboardValue)
                            
                            totalScore = totalScore + self.score;
                            
                            let userHandle = self.ref.child("Users").child(uid)
                            
                            var userValue = [
                                "name": name,
                                "level": self.CalcLevel(score: totalScore),
                                "totalScore": totalScore,
                                "profileImage" : profileImage
                            ] as [String:Any]
                            
                            userHandle.updateChildValues(userValue)
                            
                        }
                    }).resume()
                }
            }
        }
    }
    
    func CalcLevel(score: Int) -> Int
    {
        if(score < 1000)
        {
            return 1
        }
        else if (score > 1000 && score < 2000)
        {
            return 2
        }
        else if (score > 2000 && score < 3000)
        {
            return 3
        }
        else if (score > 3000 && score < 4000)
        {
            return 4
        }
        else if (score > 4000 && score < 5000)
        {
            return 5
        }
        else if (score > 5000 && score < 6000)
        {
            return 6
        }
        else if (score > 6000 && score < 7000)
        {
            return 7
        }
        else if (score > 7000 && score < 8000)
        {
            return 8
        }
        else if (score > 9000 && score < 10000)
        {
            return 9
        }
        else if (score > 10000 && score < 11000)
        {
            return 10
        }
        else
        {
            return 11
        }
    }

}
