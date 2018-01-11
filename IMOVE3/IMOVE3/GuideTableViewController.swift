//
//  GuideTableViewController.swift
//  IMOVE3
//
//  Created by Fhict on 11/01/2018.
//  Copyright © 2018 fontys. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

class GuideTableViewController: UITableViewController {
    
    var ref:DatabaseReference!
    var refHandle:UInt!
    
    var group = [Guide]()
    var type:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        ref = Database.database().reference()
        
        LoadGuide(type: type)
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return group.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guideCell", for: indexPath) as! GuideTableViewCell

        cell.nameLabel.text = group[indexPath.row].name

        return cell
    }
    
    func LoadGuide(type:String)
    {
        refHandle = ref.child("Guide").child(type).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let name = dictionary["name"] as! String
                let info = dictionary["description"] as! String
                let picture = dictionary["picture"] as! String
                
                var guide = Guide(name: name, info: info, picture: picture)
                self.group.append(guide)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "guideOverview" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destination as! GuideViewController
                let value = group[indexPath.row]
                controller.guideItem = value
            }
        }
    }

}
