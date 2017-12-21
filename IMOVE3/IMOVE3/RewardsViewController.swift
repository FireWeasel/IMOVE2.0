//
//  RewardsViewController.swift
//  IMOVE3
//
//  Created by Fhict on 21/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RewardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var tableRewards: UITableView!
    
    var ref:DatabaseReference!
    var refHandle:UInt!
    
    var rewards = [Reward]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableRewards.delegate = self
        tableRewards.dataSource = self
        ref = Database.database().reference()
        LoadProfile()
        LoadRewards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCell", for:indexPath) as! RewardTableViewCell
        cell.rewardName?.text = rewards[indexPath.row].name
        cell.rewardPoints?.text = String(rewards[indexPath.row].points)
        return cell
    }
    
    
    
    
    func LoadRewards()
    {
        refHandle = ref.child("Rewards").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let name = dictionary["name"] as! String
                let code = dictionary["code"] as! String
                let price = dictionary["price"] as! Int
                let desc = dictionary["desc"] as! String
                
                let reward = Reward(name: name, code: code, points: price, desc: desc)
                
                self.rewards.append(reward)
                DispatchQueue.main.async {
                    self.tableRewards.reloadData()
                }
            }
        })
    }
    
    
    
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
                            self.pointsLabel.text = String(user.totalScore)
                            
                            
                        }
                    }).resume()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChooseRewards" {
            if let indexPath = self.tableRewards.indexPathForSelectedRow {
                let controller = segue.destination as! RewardBuyViewController
                let value = rewards[indexPath.row]
                let points = Int(pointsLabel.text!)
                print(value)
                controller.reward = value
                controller.points = points
            }
        }
    }


}
