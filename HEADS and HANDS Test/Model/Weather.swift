//
//  Temperature.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import ObjectMapper

class Weather: NSObject, Mappable {
    var name: String?
    var tempMin: Float?
    var tempMax: Float?
    var temp: Float?
    var specification: [WeatherDescription]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        name <- map["name"]
        tempMin <- map["main.temp_min"]
        tempMax <- map["main.temp_max"]
        temp <- map["main.temp"]
        specification <- map["weather"]
        
    }

}

