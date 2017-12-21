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
        
        let alertController = UIAlertController(title: "Point: " + String(Double(gradeLabel.text!)!/10), message: "You earned: " + String(points) + " Points", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
