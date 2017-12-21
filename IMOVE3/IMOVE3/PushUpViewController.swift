//
//  PushUpViewController.swift
//  IMOVE3
//
//  Created by Fhict on 08/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class PushUpViewController: UIViewController {

    @IBOutlet weak var UICountButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var ExerciseButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    var challenge:ChallengeAnnotation!
    var leaderboard = [LeaderBoard]()
    var timer = Timer()
    var seconds = 10
    var isTimerRunning = false
    var counter:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExerciseButton.layer.cornerRadius = 10
        ExerciseButton.clipsToBounds = true
        UICountButton.layer.cornerRadius = 80
        UICountButton.clipsToBounds = true
        print(challenge.name)
        self.nameLabel.text = challenge.name!
        self.descLabel.text = challenge.desc!
        startTimer()
        
        // Do any additional setup after loading the view.
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PushUpViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if(seconds < 1)
        {
            let popUp = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "completedView") as! CompletedChallengeViewController
            self.addChildViewController(popUp)
            popUp.challenge = self.challenge
            //popUp.nameLabel.text = self.challenge.name
            popUp.count = self.counter
            popUp.leaderboardList = self.leaderboard
            popUp.view.frame = self.view.frame
            self.view.addSubview(popUp.view)
            popUp.didMove(toParentViewController: self)
            timer.invalidate()
            
            
        } else {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    
    @IBAction func CountButton(_ sender: Any) {
        //Adds the count to the value of the button.
        let Count = UICountButton.title(for: .normal)
        let intCount = Int(Count!)! + 1
        let newCount = String(intCount)
        UICountButton.setTitle(newCount, for: .normal)
        self.counter = intCount
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = (Int(time)%1) * 1000
        return String(format:"%02i:%02i:%02i", minutes, seconds, milliseconds)
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
