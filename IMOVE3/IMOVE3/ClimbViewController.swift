//
//  ClimbViewController.swift
//  IMOVE3
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit

class ClimbViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var exercizeButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var parcourLabel: UILabel!
    @IBOutlet weak var parcourImage: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    var challenge:ChallengeAnnotation!
    
    var timer = Timer()
    var seconds = 0
    var isTimerRunning = false
    var pointsEarned = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exercizeButton.layer.cornerRadius = 10
        exercizeButton.clipsToBounds = true
        self.nameLabel.text = challenge.name!
        self.descLabel.text = challenge.desc!
        LoadChallenge()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func Start(_ sender: UIButton) {
        startTimer()
    }
    
    @IBAction func Finish(_ sender: UIButton) {
        stopTimer()
        pointsEarned = 250 - seconds;
        let alertController = UIAlertController(title: "Finished!", message: "You earned: " + String(pointsEarned) + " Points", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func Stop(_ sender: UIButton) {
        stopTimer()
    }
    
    @IBAction func Switch(_ sender: UISwitch) {
        if(sender.isOn)
        {
            LoadChallenge()
        }
        else
        {
            loadParcour()
        }
    }
    
    func LoadChallenge()
    {
        challengeLabel.isHidden = false
        parcourLabel.isHidden = true
        stopButton.isHidden = false
        timerLabel.isHidden = false
        startButton.isHidden = false
        finishButton.isHidden = false
        stopButton.isHidden = false
        exercizeButton.isHidden = false
        descLabel.isHidden = false
        parcourImage.isHidden = true
        imageLabel.isHidden = true
    }
    
    func loadParcour()
    {
        challengeLabel.isHidden = true
        parcourLabel.isHidden = false
        stopButton.isHidden = true
        timerLabel.isHidden = true
        startButton.isHidden = true
        finishButton.isHidden = true
        stopButton.isHidden = true
        exercizeButton.isHidden = true
        descLabel.isHidden = true
        parcourImage.isHidden = false
        imageLabel.isHidden = false
    }

    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ClimbViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func stopTimer(){
        timer.invalidate()
    }
    
    @objc func updateTimer()
    {
        seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = (Int(time)%1) * 1000
        return String(format:"%02i:%02i:%02i", minutes, seconds, milliseconds)
    }

}
