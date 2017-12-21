//
//  FriendViewController.swift
//  IMOVE3
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class FriendViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var ref:DatabaseReference!
    var refHandle:UInt!
    var friends = [User]()
    @IBOutlet weak var friendsTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.friendsTable.delegate = self
        self.friendsTable.dataSource = self
        ref = Database.database().reference()
        LoadFriends()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 50
     }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for:indexPath) as! FriendsTableViewCell
        cell.nameLabel?.text = friends[indexPath.row].name
        cell.levelLabel?.text = String(friends[indexPath.row].level)
        let friend = friends[indexPath.row]
        if let friendImageURL = friend.profileImage {
            let url = URL(string: friendImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.profileImageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
        return cell
    }
    
    
    func LoadFriends(){
        let uid = (Auth.auth().currentUser?.uid)!
        refHandle = ref.child("Friends").child(uid).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let name = dictionary["name"] as! String
                let level = dictionary["level"] as! Int
                let picture = dictionary["picture"] as! String
                
                var user = User(name: name, profileImage: picture, level: level)
                self.friends.append(user)
                
                DispatchQueue.main.async {
                    self.friendsTable.reloadData()
                }
            }
        })
    }

}
