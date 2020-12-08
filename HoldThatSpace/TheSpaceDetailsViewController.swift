//
//  TheSpaceDetailsViewController.swift
//  HoldTheSpace
//
//  Created by Mac on 4/17/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TheSpaceDetailsViewController: UIViewController,  CLLocationManagerDelegate,MKMapViewDelegate  {

    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    
    @IBOutlet weak var timeLbl: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       print("The Best Space Choosen By the Seeker For The Parking of the vehicle userId : ", self.uID!)
 print("The Best Space Choosen By the Seeker For The Parking of the vehicle   ")
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
        
        if let coor = self.mapView.userLocation.location?.coordinate{
            self.mapView.setCenter(coor, animated: true)
        }

        
        
        let url = "http://holdthatspace.com/webservices/spaceDetails.php"
        self.callSpaceDetailWebservice(url: url)

        // Do any additional setup after loading the view.
    }
//CAll Button Action
    
    @IBAction func callTheSpaceOwnerBtnClicked(_ sender: Any) {
   
        guard let number = URL(string: "tel://" + "1234567890") else { return }
        UIApplication.shared.open(number)
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        self.mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        print ("coordinates",annotation.coordinate )
        annotation.title = "AdixSoft"
        annotation.subtitle = "current location"
        self.mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func backBtnClicked(_ sender: Any) {
   
//       self.dismiss(animated: true, completion: nil)
self.navigationController?.popViewController(animated: true)
    
    }
   var response1 : String!
    var uID : String!
//    var data : [AnyObject]!
    
    func callSpaceDetailWebservice(url : String)
    {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "POST"
//        let userName = self.userNameField.text
//        let passWord = self.passWordField.text
//        let json: [String: Any] = ["userId":self.uID,
//            "sId":"1"]
//        let uid : String  = self.uID
        let json: [String : Any] = ["userId" : "1",
                                   "sId" : "1" ]
        
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? [String:AnyObject]{
                    print("responsefromwebService",responseJSON)
                    print(responseJSON["code"]!)
                    //                    print(responseJSON["data"]?["userId"]!! as Any )
                    
                    
//                    print("userType:",responseJSON["data"]?["userType"] as! String)
                    self.response1 = responseJSON["code"] as? String
                    
                    print(self.response1)
                    
                    //Check response from the sever
                    if self.response1 == "200"
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call Successful and can perform other operatios
                            print("Space found Successful")
                            
                            
                            self.descriptionTextField.text = responseJSON["data"]?["sAddress"] as? String
                            self.addressLbl.text = responseJSON["data"]?["sLandmark"] as? String
                            self.titleLbl.text = responseJSON["data"]?["spaceTitle"] as? String

                            self.timeLbl.text = responseJSON["data"]?["spaceTime"] as? String
                            
                     
                        }
                        
                    }
                        
                    else
                    {
                        OperationQueue.main.addOperation {
                            
                            //API call failed and perform other operations
                            print("Space Not Find")
                            
                        }
                        
                    }
                    
                    
                }
            }
            catch {
                print("Error -> \(error)")
            }
            
            
            
        }
        
        
        task.resume()
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}
