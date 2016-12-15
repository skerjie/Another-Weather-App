//
//  Utilities.swift
//  WeatherApp
//
//  Created by Andrei Palonski on 15.12.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import Foundation


class Utilities {
  
  func getStorage() -> UserDefaults {
    return UserDefaults.standard
  }
  
  func setSkinType(value: String) {
    let defaults = getStorage()
    defaults.set(value, forKey: defaultKeys.skinType)
    defaults.synchronize()
  }
  
  func getSkinType() -> String {
    let defaults = getStorage()
    if let result = defaults.string(forKey: defaultKeys.skinType) {
      return result
    }
    return SkinType().type1
  }
  
}
