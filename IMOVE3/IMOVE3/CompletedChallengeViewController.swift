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
        self.nrLabel.text = String(self.score)
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboardList.count
        
    }
    
    @IBAction func completeChallengeButton(_ sender: Any) {
        LoadProfile()
        let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
        self.present(VC1, animated:true, completion: nil)
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for:indexPath) as! LeaderboardTableViewCell
        cell.nameLabel?.text = leaderboardList[indexPath.row].name
        let leaderboard = leaderboardList[indexPath.row]
        if let leaderBoardImages = leaderboard.profilePicture {
            let url = URL(string: leaderBoardImages)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
        
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
                var challenges = dictionary["challenges"] as! Int
                
                var user = User(name: name, profileImage: profileImage!, totalScore: totalScore, level: level, challenges:challenges)
                
                /*var image:UIImage!
                if let imageURL = user.profileImage {
                    let url = URL(string: imageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                        if error != nil {
                            print(error!)
                            return
                        }*/
                DispatchQueue.main.async {
                            //image = UIImage(data:data!)
                            
                            //update object in database for leaderboars
                            let leaderboardHandle = self.ref.child("Leaderboards").child(self.challenge.name).child(uid)
                            var leaderboardValue = [
                                "name": name,
                                "points": self.score,
                                "picture": profileImage
                                ] as [String : Any]
                            leaderboardHandle.updateChildValues(leaderboardValue)
                            
                            totalScore = totalScore + self.score
                            challenges = challenges + 1
                            
                            let userHandle = self.ref.child("Users").child(uid)
                            
                            var userValue = [
                                "name": name,
                                "level": self.CalcLevel(score: totalScore),
                                "totalScore": totalScore,
                                "profileImage" : profileImage,
                                "challenges": challenges
                            ] as [String:Any]
                            
                            userHandle.updateChildValues(userValue)
                            
                  }
            }
        }
    }
    
    func CalcLevel(score: Int) -> Int
    {
        let Score1 = score / 1000
        let Score2 = ((score - 10000) / 2000) + 10
        let Score3 = ((score - 30000) / 3000) + 20
        
        if(score  < 10000)
        {
            return Score1
        }
        else if(score > 10000 && score <= 30000)
        {
            return Score2
        }
        else
        {
            return Score3
        }
    }

}
