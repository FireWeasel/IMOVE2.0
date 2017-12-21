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
        
        let alertController = UIAlertController(title: "You're done!", message: "You earned: " + String(pointsEarned) + " Points", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
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
