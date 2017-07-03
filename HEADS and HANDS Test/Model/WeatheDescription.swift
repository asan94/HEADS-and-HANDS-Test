//
//  Main.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import ObjectMapper

class WeatherDescription: Mappable {
    var specification: String?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        specification <- map["description"]
    }
    
}
