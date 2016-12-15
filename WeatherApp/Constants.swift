//
//  Constants.swift
//  WeatherApp
//
//  Created by Andrei Palonski on 15.12.16.
//  Copyright © 2016 Andrei Palonski. All rights reserved.
//

import Foundation



struct WeatherURL {
  
  private let baseUrl = "https://api.worldweatheronline.com/premium/v1/weather.ashx"
  private let key = "&key=85310973f72e4c4da38170605160910"
  private let numDaysForecast = "&num_of_days=1"
  private let format = "&format=json"
  
  private var coordStr = ""
  
  init(lat: String, long: String) {
    self.coordStr = "?q=\(lat),\(long)"
  }
  
  func getFullUrl() -> String {
    return baseUrl + coordStr + key + numDaysForecast + format
  }
  
}

struct SkinType {
  
  let type1 = "Type 1 - Pale / Light"
  let type2 = "Type 2 - White / Fair"
  let type3 = "Type 3 - Medium"
  let type4 = "Type 4 - Olive Brown"
  let type5 = "Type 5 - Dark Brown"
  let type6 = "Type 6 - Very Dark / Black"
  
}

struct defaultKeys {
  static let skinType = "skinType"
}
