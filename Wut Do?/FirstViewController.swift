//
//  FirstViewController.swift
//  Wut Do?
//
//  Created by Michael MacCallum on 5/28/17.
//  Copyright © 2017 Robyn Cute. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class FirstViewController: UIViewController {
    @IBOutlet fileprivate weak var mapView: MKMapView!
    
    fileprivate let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        //The following code gets the Google API key
        //get the path of the plist file
        guard let plistPath = Bundle.main.path(forResource: "Property List", ofType: "plist") else { return }
        //load the plist as data in memory
        guard let plistData = FileManager.default.contents(atPath: plistPath) else { return }
        //use the format of a property list (xml)
        var format = PropertyListSerialization.PropertyListFormat.xml
        //convert the plist data to a Swift Dictionary
        guard let  plistDict = try! PropertyListSerialization.propertyList(from: plistData, options: .mutableContainersAndLeaves, format: &format) as? [String : AnyObject] else { return }
        //access the values in the dictionary
        if let apiKey = plistDict["Google API Key"] as? String {
            //do something with your value
            GMSServices.provideAPIKey(apiKey)
            print(apiKey)
        }
        
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, id == "search", let destination = segue.destination as? SearchViewController else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        destination.region = mapView.region
    }
}

extension FirstViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }

        
        let region = MKCoordinateRegionMake(currentLocation.coordinate, MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    }
}
