//
//  AddFriendTableViewController.swift
//  IMOVE3
//
//  Created by Fhict on 21/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class AddFriendTableViewController: UITableViewController {

    var friends = [User]()
    var ref:DatabaseReference!
    var refHandle:UInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        LoadUsers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addFriendCell", for: indexPath) as! AddFriendTableViewCell
        cell.nameLabel?.text = friends[indexPath.row].name
        print("hey")
        let friend = friends[indexPath.row]
        if let friendImageURL = friend.profileImage {
            let url = URL(string: friendImageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    cell.profilePicImageView?.image = UIImage(data: data!)
                }
            }).resume()
        }

        return cell
    }
    
    @IBAction func addFriend(_ sender: Any) {
        let buttonPosition : CGPoint = (sender as AnyObject).convert((sender as AnyObject).bounds.origin, to: self.tableView)
        
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)!
        
            let uid = (Auth.auth().currentUser?.uid)!
            let friend = friends[indexPath.row]
            let friendHandle = self.ref.child("Friends").child(uid).child(friend.name)

            var userValue = [
                "name": friend.name,
                "picture" : friend.profileImage,
                "level": friend.level
                ] as [String:Any]
            
            friendHandle.updateChildValues(userValue)
        
    }
    
    
    func LoadUsers(){
        
        refHandle = ref.child("Users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let name = dictionary["name"] as! String
                let level = dictionary["level"] as! Int
                let picture = dictionary["profileImage"] as! String
                
                var user = User(name: name, profileImage: picture, level: level)
                self.friends.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
