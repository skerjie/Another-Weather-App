//
//  ViewController.swift
//  WeatherApp
//
//  Created by Andrei Palonski on 14.12.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var skinTypeLabel: UILabel!
  var locationManager = CLLocationManager()
  var coords = CLLocationCoordinate2D(latitude: 40, longitude: 40)
  var skinType = SkinType().type1 {
    didSet{
      skinTypeLabel.text = "Skin: " + self.skinType
      Utilities().setSkinType(value: skinType)
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    skinType = Utilities().getSkinType()
    skinTypeLabel.text = "Skin: " + skinType
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  
  @IBAction func changeSkinButtonTapped(_ sender: Any) {
    let alert = UIAlertController(title: "Skin Type!", message: "Please choose skin type!", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: SkinType().type1, style: .default, handler: { (action) in
      self.skinType = SkinType().type1
    }))
    alert.addAction(UIAlertAction(title: SkinType().type2, style: .default, handler: { (action) in
      self.skinType = SkinType().type2
    }))
    alert.addAction(UIAlertAction(title: SkinType().type3, style: .default, handler: { (action) in
      self.skinType = SkinType().type3
    }))
    alert.addAction(UIAlertAction(title: SkinType().type4, style: .default, handler: { (action) in
      self.skinType = SkinType().type4
    }))
    alert.addAction(UIAlertAction(title: SkinType().type5, style: .default, handler: { (action) in
      self.skinType = SkinType().type5
    }))
    alert.addAction(UIAlertAction(title: SkinType().type6, style: .default, handler: { (action) in
      self.skinType = SkinType().type6
    }))
    self.present(alert, animated: true, completion: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("location has changed")
    
    if status == .authorizedWhenInUse {
      getLocation()
    } else if status == .denied {
      let alert = UIAlertController(title: "Error", message: "Go to settings and allow this app to access you location!", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }

  func getLocation() {
    if let loc = locationManager.location?.coordinate {
      coords = loc
      getWeatherData()
    }
  }
  
  func getWeatherData() {
    let url = WeatherURL(lat: String(coords.latitude), long: String(coords.longitude)).getFullUrl()
    print("URL \(url)")
    
    Alamofire.request(url).responseJSON { response in
   //   print(response.request)  // original URL request
   //   print(response.response) // HTTP URL response
   //   print(response.data)     // server data
      print(response.result)   // result of response serialization
      
      if let JSON = response.result.value {
        print("JSON: \(JSON)")
      }
    }
  }

}

