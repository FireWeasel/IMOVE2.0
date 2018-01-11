//
//  GuideViewController.swift
//  IMOVE3
//
//  Created by Fhict on 11/01/2018.
//  Copyright © 2018 fontys. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descTB: UITextView!
    @IBOutlet weak var pictureBox: UIImageView!
    
    var guideItem:Guide?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = guideItem?.name
        self.descTB.text = guideItem?.info
        
        
        if let guideImageUrl = guideItem?.picture {
            let url = URL(string: guideImageUrl)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    self.pictureBox?.image = UIImage(data: data!)
                }
            }).resume()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
