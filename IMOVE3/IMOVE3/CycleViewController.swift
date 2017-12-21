//
//  CycleViewController.swift
//  IMOVE3
//
//  Created by Fhict on 14/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CycleViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    //MARK: Properties
    @IBOutlet weak var CountDown: UILabel!
    @IBOutlet weak var ExerciseButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var myLocation = CLLocationCoordinate2D()
    
    let sourceLocation = CLLocationCoordinate2D(latitude: 51.447818136328806, longitude: 5.477886199951172)
    let destinationLocation = CLLocationCoordinate2D(latitude: 51.45011823499911, longitude: 5.481147766113281)
    
    var challenge:ChallengeAnnotation!
    var timer = Timer()
    var seconds = 0
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ExerciseButton.layer.cornerRadius = 10
        ExerciseButton.clipsToBounds = true
        self.nameLabel.text = challenge.name!
        self.descLabel.text = challenge.desc!
        startTimer()
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.mapView.delegate = self
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Start"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Finish"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
        
    }
    
    //MARK: Actions
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(PushUpViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        seconds += 1
        CountDown.text = timeString(time: TimeInterval(seconds))
        if(myLocation.latitude > (destinationLocation.latitude - 0.0001) &&
            myLocation.latitude < (destinationLocation.latitude + 0.0001) &&
            myLocation.longitude < (destinationLocation.longitude + 0.0001) &&
            myLocation.longitude > (destinationLocation.longitude - 0.0001))
        {
            let points = 400 - seconds
            
            let alertController = UIAlertController(title: "Your time is " + timeString(time: TimeInterval(seconds)), message: "You earned: " + String(points) + " Points", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        //Set the map span to the users location.
        let location = locations[0]
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = true
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }

    

}
