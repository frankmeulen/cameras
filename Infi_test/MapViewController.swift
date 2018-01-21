//
//  MapViewController.swift
//  Infi_test
//
//  Created by Frank van der Meulen on 21-01-18.
//  Copyright © 2018 Frank van der Meulen. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    
    var camerasArray = [CameraDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        (self.mapView.frame.maxX / 2 - 25)
//        (self.mapView.frame.maxY - 70)

        
        // Do any additional setup after loading the view.
    }
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 52.092876, longitude: 5.104480, zoom: 15.0, bearing: 0, viewingAngle: 45)
        self.mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.mapView.delegate = self
        self.view = mapView
        
        let button = UIButton(frame: CGRect(x: (UIScreen.main.bounds.maxX / 2 - 30),y: (UIScreen.main.bounds.maxY - 80) ,width: 60.0,height: 60.0))
        self.view.addSubview(button)
        button.backgroundColor = UIColor(red: 0.0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        button.setTitle("Back",for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        
        
//        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        
      
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        print("yes", camerasArray)
        
        //Get camera objects
        for camera in camerasArray {
            print("Yes",camera)
            //Marker image
            let markerImageView = UIImageView()
            markerImageView.image = UIImage(named:"video-camera-icon.png")
            markerImageView.layer.frame.size.height = 50
            markerImageView.layer.frame.size.width = 50
//            markerImageView.layer.cornerRadius = markerImageView.layer.frame.height/2
//            markerImageView.layer.masksToBounds = true
            
            // Create marker
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: Double(camera.cameraLatitude)!, longitude: Double(camera.cameraLongitude)!)
            marker.iconView = markerImageView
            marker.snippet = camera.cameraNaam
            marker.title = "Camera"
            marker.map = self.mapView
            
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonClicked() {
        self.navigationController?.popViewController(animated: true)
        
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
