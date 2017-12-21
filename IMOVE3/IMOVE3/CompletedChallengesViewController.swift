//
//  CompletedChallengesViewController.swift
//  IMOVE_Test
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 Fhict. All rights reserved.
//

import UIKit

class CompletedChallengesViewController: UIViewController {

    @IBOutlet weak var completedBTN: UIButton!
    @IBOutlet weak var nrLb: UILabel!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var pointsLB: UILabel!
    @IBOutlet weak var leaderboardTB: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
