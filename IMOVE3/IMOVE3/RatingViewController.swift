//
//  RatingViewController.swift
//  IMOVE3
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var gradeLabel: UILabel!
    
    var leaderboards = [LeaderBoard]()
    var challenge:ChallengeAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        gradeLabel.text = "\(currentValue)"
    }
    
    @IBAction func Grade(_ sender: UIButton) {
        var points = (Int(gradeLabel.text!)! * 3)
        
        let popUp = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "completedView") as! CompletedChallengeViewController
        self.addChildViewController(popUp)
        popUp.challenge = self.challenge
        popUp.score = points
        popUp.leaderboardList = self.leaderboards
        popUp.view.frame = self.view.frame
        self.view.addSubview(popUp.view)
        popUp.didMove(toParentViewController: self)
    }
    
    
}
