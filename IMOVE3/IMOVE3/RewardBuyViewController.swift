//
//  RewardBuyViewController.swift
//  IMOVE3
//
//  Created by Fhict on 21/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class RewardBuyViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    var reward:Reward!
    var points:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        codeLabel.isHidden = true;
        nameLabel.text = reward.name
        priceLabel.text = String(reward.points)
        codeLabel.text = "Code: " + reward.code
        descLabel.text = reward.desc
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BuyReward(_ sender: UIButton) {
        
        if(reward.points <= points)
        {
            codeLabel.isHidden = false
        }
        else{
            let alertController = UIAlertController(title: "Not enough Points", message: "you have to little points, complete more challenges", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
