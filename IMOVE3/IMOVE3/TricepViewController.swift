//
//  TricepViewController.swift
//  IMOVE3
//
//  Created by Fhict on 15/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class TricepViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var setScoreButton: UIButton!
    @IBOutlet weak var sliderDescLabel: UILabel!
    
    var challenge:ChallengeAnnotation!
    var leaderboards = [LeaderBoard]()
    
    var timer = Timer()
    var seconds = 10
    var isTimerRunning = false
    var pointsEarned = 0
    var triceps = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exerciseButton.layer.cornerRadius = 10
        exerciseButton.clipsToBounds = true
        self.nameLabel.text = challenge.name!
        self.descLabel.text = challenge.desc!
        Hide()
        startTimer()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SliderValueChanged(_ sender: UISlider) {
        triceps = Int(sender.value)
        scoreLabel.text = "\(triceps)"
    }
    
    
    @IBAction func SetScore(_ sender: UIButton) {
        pointsEarned = triceps * 3
        
        let popUp = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "completedView") as! CompletedChallengeViewController
        self.addChildViewController(popUp)
        popUp.challenge = self.challenge
        popUp.score = pointsEarned
        popUp.leaderboardList = self.leaderboards
        popUp.view.frame = self.view.frame
        self.view.addSubview(popUp.view)
        popUp.didMove(toParentViewController: self)
        
    }
    
    
    @IBAction func HideKeyBoard(_ sender: Any) {
        
    }
    
    
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(TricepViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func updateTimer()
    {
        seconds -= 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
        if(seconds == 0)
        {
            Show()
            stopTimer()
        }
        
    }
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = (Int(time)%1) * 1000
        return String(format:"%02i:%02i:%02i", minutes, seconds, milliseconds)
    }
    
    func Show()
    {
        
        slider.isHidden = false
        sliderDescLabel.isHidden = false
        setScoreButton.isHidden = false
        //descLabel.isHidden = false
        scoreLabel.isHidden = false
    }
    
    func Hide()
    {
        
        slider.isHidden = true
        sliderDescLabel.isHidden = true
        setScoreButton.isHidden = true
        //descLabel.isHidden = true
        scoreLabel.isHidden = true
    }

}
