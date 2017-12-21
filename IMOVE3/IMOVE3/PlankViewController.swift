//
//  PlankViewController.swift
//  IMOVE3
//
//  Created by Fhict on 15/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class PlankViewController: UIViewController {

    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var exerciseButton: UIButton!
    
    var challenge:ChallengeAnnotation!
    
    var timer = Timer()
    var seconds = 10
    var isTimerRunning = false
    var pointsEarned = 200
    var counter:Int?
    var leaderboard = [LeaderBoard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseButton.layer.cornerRadius = 10
        exerciseButton.clipsToBounds = true
        self.nameLabel.text = challenge.name!
        self.descLabel.text = challenge.desc!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Start(_ sender: Any) {
        startTimer()
    }
    
    //Stop challenge earle
    @IBAction func Stop(_ sender: UIButton) {
        stopTimer()
        let alertController = UIAlertController(title: "Finished Planking", message: "You earned: " + String(pointsEarned - seconds) + " Points", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PlankViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func updateTimer()
    {
        if(seconds < 1)
        {
            let popUp = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "completedView") as! CompletedChallengeViewController
            self.addChildViewController(popUp)
            popUp.challenge = self.challenge
            //popUp.nameLabel.text = self.challenge.name
            popUp.count = (pointsEarned - seconds)
            popUp.leaderboardList = self.leaderboard
            popUp.view.frame = self.view.frame
            self.view.addSubview(popUp.view)
            popUp.didMove(toParentViewController: self)
            timer.invalidate()
        }
        else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
        
        
        //Finish challenge when done correctly, planked the whole 2 minuts
       /* if(seconds == 0)
        {
            stopTimer()
            let alertController = UIAlertController(title: "Finished Planking", message: "You earned: " + String(pointsEarned) + " Points", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }*/
    }
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = (Int(time)%1) * 1000
        return String(format:"%02i:%02i:%02i", minutes, seconds, milliseconds)
    }
    
}
