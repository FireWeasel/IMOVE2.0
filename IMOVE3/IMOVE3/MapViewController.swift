//
//  MapViewController.swift
//  IMOVE3
//
//  Created by Fhict on 23/11/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth

class MapViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var ButtonRecenter: UIButton!
    @IBOutlet weak var ProfileButton: UIButton!
    var locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    var ref:DatabaseReference!
    var refHandle:UInt!
    var leaderboards = [LeaderBoard]()
    @IBOutlet weak var ProfileLevelLabel: UILabel!
    
    var coordinates: [[Double]]!
    var pointers = [ChallengeAnnotation]()
    var names:[String]!
    var descriptions:[String]!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ButtonFeatures()
        LocationManagerStartUp()
        ref = Database.database().reference()
        LoadProfile()
        //SetChallenges()
        
        coordinates = [[51.441748,5.483254],[51.445610,5.468737],[51.456007,5.476780]]
        names = ["Push-Up Challenge","Cycling Challenge","Climbing Challenge"]
        descriptions = ["Hey there sporter, Try to do as maney push-ups as you can within 5 minutes. Try to beat your friends!","Hey there sporter, try to cycle this route as fast as you can. Try to set a good time to beat all your friends","Hello sporter, you have arrived at a great climbing structure, Try to set a time climbing from front to back."]
        self.Map.delegate = self

        self.ProfileButton.layer.cornerRadius = self.ProfileButton.frame.size.width / 2;
        self.ProfileButton.clipsToBounds = true;
        loadPointer()
    }
    
    func loadPointer(){
        refHandle = ref.child("Locations").observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let lat = dictionary["latitude"] as! Double
                let long = dictionary["longtitude"] as! Double
                let image = dictionary["image"] as! String
                let desc = dictionary["desc"] as! String
                let name = dictionary["name"] as! String
                let rating = dictionary["rating"] as! Int
                let type = dictionary["type"] as! String
                let location = ChallengeAnnotation(coordinate: CLLocationCoordinate2D(latitude:lat, longitude:long), image: image, desc:desc, name:name, rating:String(rating), type: Type(rawValue: type)!)
                print(location)
                self.pointers.append(location)
                self.Map.addAnnotation(location)
            }
        })
        
        
           // let coordinate = pointers[1]
           // self.Map.addAnnotation(coordinate)
 
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TapMap(_ sender: Any) {
        ButtonRecenter.isHidden = false
        locationManager.stopUpdatingLocation()
        
    }
    
    @IBAction func CenterOnUser(_ sender: Any) {
        locationManager.startUpdatingLocation()
        ButtonRecenter.isHidden = true;
    }
    

    
    
    //MARK: Actions
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //Set the map span to the users location.
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        Map.setRegion(region, animated: true)
        self.Map.showsUserLocation = true
    
    }
    
    func ButtonFeatures()
    {
        ButtonRecenter.layer.cornerRadius = 4
        ButtonRecenter.isHidden = true
    }
    
    func LocationManagerStartUp()
    {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.Map.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        }else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "chal")
        return annotationView
    }

    
   
    func mapView(_ mapView: MKMapView,
                 didSelect view: MKAnnotationView)
    {
        // 1
        if view.annotation is MKUserLocation
        {
            // Don't proceed with custom callout
            return
        }
        //2
        let challengeAnnotation = view.annotation as! ChallengeAnnotation
        let views = Bundle.main.loadNibNamed("CustomAnnotationView", owner: nil, options: nil)
        let calloutView = views?[0] as! CustomAnnotationView
        calloutView.challengeObjec = challengeAnnotation
        calloutView.challengeName.text = challengeAnnotation.name
        calloutView.challengeDescription.text = challengeAnnotation.desc
        calloutView.toughnessLabel.text = challengeAnnotation.rating
        refHandle = ref.child("Leaderboards").child(challengeAnnotation.name).observe(.childAdded, with: {(snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                let name = dictionary["name"] as! String
                let points = dictionary["points"] as! Int
                let picture = dictionary["picture"] as! String
                var leaderboard = LeaderBoard(name: name, score: points, picture: picture)
                print(leaderboard)
                
                self.leaderboards.append(leaderboard)
                print(self.leaderboards)
                calloutView.leaderboard = self.leaderboards
            }
        })
        // downloading image from storage
        var image:UIImage!
        if let imageURL = challengeAnnotation.image {
            let url = URL(string: imageURL)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    image = UIImage(data:data!)
                    calloutView.challengeImage.image = image
                    //print(data)
                }
            }).resume()
        }
        // 2
        //let button = UIButton(frame: calloutView.starbucksPhone.frame)
        //button.addTarget(self, action: #selector(ViewController.callPhoneNumber(sender:)), for: .touchUpInside)
        //calloutView.addSubview(button)
        // 3
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
       // mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self)
        {
            for subview in view.subviews
            {
                subview.removeFromSuperview()
            }
        }
    }
    
    func LoadProfile()
    {
        let uid = (Auth.auth().currentUser?.uid)!
        ref.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject]{
                let name = dictionary["name"] as! String
                let level = dictionary["level"] as! Int
                let totalScore = dictionary["totalScore"] as! Int
                let profileImage = dictionary["profileImage"] as? String
                
                var user = User(name: name, profileImage: profileImage!, totalScore: totalScore, level: level)
                
                var image:UIImage!
                if let imageURL = user.profileImage {
                    let url = URL(string: imageURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data,response ,error ) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        DispatchQueue.main.async {
                            image = UIImage(data:data!)
                            
                            self.ProfileButton.setImage(image, for: UIControlState.normal)
                            //image = image
                            self.ProfileLevelLabel.text = String(user.level)
                            
                            
                        }
                    }).resume()
                }
            }
        }
    }
}

