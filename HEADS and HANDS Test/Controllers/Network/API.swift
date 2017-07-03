//
//  API.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireNetworkActivityIndicator
enum APIVersion: String {
    case V1 = "2.5"
}
struct API {
   
    static let baseURLString: String = API.setupEnv()
    
    static var additionalHeaders: [String: String] = [
        "Content-Type": "application/json",
        
    ]
    
    static func setupEnv() -> String {
        NetworkActivityIndicatorManager.shared.isEnabled = true
        
        
        return ConstantsAPI.kBaseUrl
    }
    
}

struct QError {
    static let domain: String = "ru.app.HEADS-and-HANDS-Test"
    
    static func info(userInfo: [String: AnyObject]) -> NSError {
        return NSError(domain: self.domain, code: -1, userInfo: userInfo)
    }
    
    static func standard(reason: String) -> NSError {
        return NSError(domain: self.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: reason])
    }
    
    static var unknown: NSError {
        return NSError(domain: self.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "An Unknown Error Occurred"])
    }
    
    static var serialization: NSError {
        return NSError(domain: self.domain, code: -1, userInfo: [NSLocalizedDescriptionKey: "A Serialization Error Occurred"])
    }
}
