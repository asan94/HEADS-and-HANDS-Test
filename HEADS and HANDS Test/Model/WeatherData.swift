//
//  Weather.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import ObjectMapper
class WeatherData: NSObject, Mappable {
    var weather: [Weather]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        self.weather <- map["list"]
    }

    
}
