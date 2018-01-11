//
//  GuideMainTableViewController.swift
//  IMOVE3
//
//  Created by Fhict on 11/01/2018.
//  Copyright © 2018 fontys. All rights reserved.
//

import UIKit

class GuideMainTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear

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

    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGuide" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let cell = tableView.cellForRow(at: indexPath)
                let controller = segue.destination as! GuideTableViewController
                print(cell?.reuseIdentifier)
                controller.type = cell?.reuseIdentifier
            }
            
        }
    }

}
