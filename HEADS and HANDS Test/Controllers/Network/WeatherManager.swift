//
//  WeatherManager.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

extension API {
    
    enum Weather: APIResource {
        case GetWeather()
        
        var request: APIRequest {
            let request: APIRequest
            switch self {
            case .GetWeather():
                let params: [String: Any] = ["lang": "ru", "type": "like", "units" :"metric", "APPID": Constants.kAPIToken, "q": "Moskow,RU"]
                request = APIRequest.GET(ConstantsAPI.kRequestWeather, version: .V1, params: params)
            }
            return request
        }
    }
}
