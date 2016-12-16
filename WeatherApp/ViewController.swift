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
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var bigTimeLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var statusLabel: UILabel!
  @IBOutlet weak var skinTypeLabel: UILabel!
  var locationManager = CLLocationManager()
  var coords = CLLocationCoordinate2D(latitude: 40, longitude: 40)
  var skinType = SkinType().type1 {
    didSet{
      skinTypeLabel.text = "Skin: " + self.skinType
      Utilities().setSkinType(value: skinType)
      getWeatherData()
    }
  }
  var uvIndex = 8
  var burnTime : Double = 10
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    skinType = Utilities().getSkinType()
    skinTypeLabel.text = "Skin: " + skinType
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  @IBAction func reminderButtonTapped(_ sender: Any) {
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .badge, .sound]) {
      (granted, error) in
      if granted {
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Time's Up!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "You are beginning to burn!", arguments: nil)
        content.sound = UNNotificationSound.default()
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: false)
        let request = UNNotificationRequest(identifier: "willburn", content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
      }
    }
    
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
      // getWeatherData()
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
        
        if let data = JSON["data"] as? Dictionary<String, AnyObject> {
          if let weather = data["weather"] as? [Dictionary<String, AnyObject>] {
            if let uv = weather[0]["uvIndex"] as? String {
              if let uvI = Int(uv) {
                self.uvIndex = uvI
                print("UVINDEX \(uvI)")
                self.updateUI(dataSuccess: true)
                return
              }
            }
          }
        }
      }
      self.updateUI(dataSuccess: false)
    }
  }
  
  func updateUI(dataSuccess: Bool) {
    
    DispatchQueue.main.async {
      // failed
      if !dataSuccess {
        self.statusLabel.text = "Failed...retrying..."
        self.getWeatherData()
        return
      }
      // success
      self.activityIndicator.stopAnimating()
      // self.activityIndicator.removeFromSuperview()
      self.statusLabel.text = "GOT UV Data"
      self.calculateBurnTime()
      print("burn time: \(self.burnTime)")
      self.bigTimeLabel.text = String(self.burnTime)
    }
  }
  
  func calculateBurnTime() {
    var minToBurn : Double = 10
    
    switch skinType {
    case SkinType().type1: minToBurn = BurnTime().burnType1
    case SkinType().type2: minToBurn = BurnTime().burnType2
    case SkinType().type3: minToBurn = BurnTime().burnType3
    case SkinType().type4: minToBurn = BurnTime().burnType4
    case SkinType().type5: minToBurn = BurnTime().burnType5
    case SkinType().type6: minToBurn = BurnTime().burnType6
    default:
      minToBurn = BurnTime().burnType1
    }
    
    burnTime = minToBurn / Double(self.uvIndex)
    
  }
  
}

