//
//  APIRequest.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import Foundation
import Alamofire

struct APIPagination {
    var page: Int
    let per: Int
    
    var params: [String:Any] {
        return ["page": self.page,
                "per": self.per]
    }
    
    init(page: Int? = nil, per: Int? = nil) {
        self.page = page ?? 1
        self.per = per ?? 10
    }
    
    mutating func next() {
        self.page = self.page + 1
    }
}

struct APIRequest: URLRequestConvertible, URLConvertible {
    let method: String
    let version: APIVersion
    let path: String
    let params: [String: Any]?
    var shouldUpload: Bool
    
    
    static func GET(_ path: String, version: APIVersion, params: [String: Any]? = nil, pagination: APIPagination? = nil) -> APIRequest {
        var params: [String: Any] = params ?? [:]
        
        if let pagination = pagination {
            for (key, value) in pagination.params {
                params.updateValue(value, forKey:key)
            }
        }
        return self.init(method: "GET", version: version, path: path, params: params, shouldUpload: false)
    }
    
    func asURLRequest() throws -> URLRequest {
        let URL = self.URLBuilder(self.path, apiVersion: self.version)
        var r = URLRequest(url: URL)
        r.httpMethod = self.method
        for (key, value) in API.additionalHeaders {
            r.setValue(value, forHTTPHeaderField: key)
        }
        print("⤴️⤴️⤴️request: \(self.method) \(URL)\n\(String(describing: self.params))\nheaders: \(String(describing: r.allHTTPHeaderFields))\n⏹⏹⏹")
        
        guard self.method != "GET" else {
            return try URLEncoding.default.encode(r, with: self.params)
        }
        
        if self.shouldUpload {
            if r.value(forHTTPHeaderField: "Content-Type") == nil {
                r.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            
            return r
        } else {
            return try URLEncoding.default.encode(r, with: self.params)
        }
        
    }
    
    func asURL() throws -> URL {
        return self.URLBuilder(self.path, apiVersion: self.version)
    }
    
    func URLBuilder(_ path: String, apiVersion: APIVersion) -> URL {
        let baseURL = URL(string: API.baseURLString)!
        let urlWithAPIVersion = baseURL.appendingPathComponent("/\(apiVersion.rawValue)/")
        return urlWithAPIVersion.appendingPathComponent(path)
        
    }
}
