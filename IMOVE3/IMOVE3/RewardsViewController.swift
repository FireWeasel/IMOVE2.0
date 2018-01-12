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

class RewardsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
   
    
    
    

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var collectionRewards: UICollectionView!
    
    var ref:DatabaseReference!
    var refHandle:UInt!
    
    
    var rewards = [Reward]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionRewards.delegate = self
        collectionRewards.dataSource = self
        
        ref = Database.database().reference()
        LoadProfile()
        LoadRewards()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardColCell", for:indexPath) as! RewardCollectionViewCell
        cell.nameLabel?.text = rewards[indexPath.row].name
        cell.pointsLabel?.text = String(rewards[indexPath.row].points)
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
                    self.collectionRewards.reloadData()
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
                var challenge = dictionary["challenges"] as! Int
                
                var user = User(name: name, profileImage: profileImage!, totalScore: totalScore, level: level, challenges: challenge)
                
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
        if segue.identifier == "ChooseRewards2" {
            let cell = sender as! UICollectionViewCell
            if let indexPath = self.collectionRewards.indexPath(for: cell) {
                print(indexPath)
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
