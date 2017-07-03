//
//  APIResource.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit

import Foundation
import Alamofire
import ObjectMapper

protocol APIResource {
    var request: APIRequest { get }
}

extension APIResource {
    @discardableResult
    func responseData(_ completionHandler: @escaping ResponseHandlerBlock) -> Request {
        return self.pureRequest(completionHandler: completionHandler)
    }
    
    @discardableResult
    func responseJSON(completionHandler: @escaping (_ json: Any?, _ error: NSError?) -> Void) -> Request {
        return self.pureRequest(completionHandler: { (data, error) in
            do {
                guard error == nil else {
                    completionHandler(nil, error)
                    return
                }
                
                let JSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                completionHandler(JSON, nil)
            } catch {
                completionHandler(nil, error as NSError)
            }
        })
    }
    @discardableResult
    func responseObject<T: Mappable>(_ mappingType: T.Type, keyPath: String? = nil, completionHandler: @escaping (_ object: T?, _ error: NSError?) -> Void) -> Request  {
        return self.responseJSON(completionHandler: { (json, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            var json = json as! [String : Any]?
            
            if let keyPath = keyPath {
                if json != nil {
                    json = json![keyPath] as! [String : Any]?
                }
            }
            
            if let parsedObject = Mapper<T>(context: nil).map(JSON: json!) {
                completionHandler(parsedObject, nil)
                return;
            }
            
            completionHandler(nil, QError.standard(reason: "ObjectMapper failed to serialize response."))
        })
    }
    
    @discardableResult
    func responseObjectArray<T: Mappable>(_ mappingType: T.Type, keyPath: String? = nil, completionHandler: @escaping (_ objects: [T]?, _ error: NSError?) -> Void) -> Request  {
        return self.responseJSON(completionHandler: { (json, error) in
            
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            var jsonToMap: [[String : Any]]?
            
            if let keyPath = keyPath {
                jsonToMap = (json as! [String : Any]?)![keyPath] as! [[String : Any]]?
            } else {
                jsonToMap = json as! [[String : Any]]?
            }
            
            
            if let parsedObject = Mapper<T>(context: nil).mapArray(JSONArray: jsonToMap!) {
                completionHandler(parsedObject, nil)
                return;
            }
            
            completionHandler(nil, QError.standard(reason: "ObjectMapper failed to serialize response."))
        })
    }
}

typealias ResponseHandlerBlock = (_ data: Data?, _ error: NSError?) -> Void

extension APIResource {
    
    @discardableResult
    fileprivate func pureRequest(completionHandler: @escaping ResponseHandlerBlock) -> Request {
        var request: DataRequest
        if self.request.shouldUpload {
            if let params = self.request.params {
                let options = JSONSerialization.WritingOptions()
                let data = try! JSONSerialization.data(withJSONObject: params, options: options)
                
                request = SessionManager.default.upload(data, to: self.request)
            } else {
                request = SessionManager.default.request(self.request)
            }
        } else {
            request = SessionManager.default.request(self.request)
        }
        
        request = request.validate(statusCode: 200...204).validate(contentType: ["application/json"])
        
        request.response(queue: DispatchQueue.main, completionHandler: { (response) -> Void in
            // logging response
            do {
                if let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? Dictionary<String, AnyObject> {
                    print("⤵️⤵️⤵️response:\n\(json)\n⏹⏹⏹")
                }
                else if let json = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? Array<AnyObject> {
                    print("⤵️⤵️⤵️response:\n\(json)\n⏹⏹⏹")
                    
                }
            } catch { }
            //
            
            let serializedError = Self.errorSerializer(data: response.data, error: response.error as NSError?, response: response.response)
            
            guard serializedError == nil else {
                return completionHandler(nil, serializedError)
            }
            
            completionHandler(response.data, nil)
        })
        return request
    }
    
    fileprivate static func errorString(_ json: [String: AnyObject]) -> String? {
        if let errorString = json["error"] as? String  {
            return errorString
        }
        if let errorString = json["message"] as? String {
            return errorString
        }
        return nil
    }
    
    fileprivate static func errorMessage(_ error: NSError?, response: HTTPURLResponse?, data: Data?) -> NSError? {
        if let response = response {
            if response.statusCode == 404 || response.statusCode == 422 || response.statusCode == 426 {
                var errorMessage: String?
                if let data = data, data.count > 0 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
                        errorMessage = self.errorString(json!)
                    } catch {}
                }
                if error != nil {
                    if let errorMessage = errorMessage {
                        var userInfo = error!.userInfo
                        userInfo["NSLocalizedFailureReason"] = errorMessage
                        let err = NSError(domain: error!.domain, code: response.statusCode, userInfo: userInfo)
                        return err
                    }
                    let err = NSError(domain: error!.domain, code: response.statusCode, userInfo: error!.userInfo)
                    return err
                }
            }
        }
        return error
    }
    
    fileprivate static func errorSerializer(data: Data?, error: NSError?, response: HTTPURLResponse?) -> NSError? {
        
        if let response = response, response.statusCode >= 200 && response.statusCode <= 204 {
            return nil
        }
        if let error = self.errorMessage(error, response: response, data: data) {
            return error
        }
        
        if let error = error {
            return error
        }
        
        guard let validData = data, validData.count > 0 else {
            let failureReason = "JSON could not be serialized. Input data was nil or zero length."
            return QError.standard(reason: failureReason)
        }
        
        do {
            // JSON error parsing
            if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, AnyObject> {
                
                if let errorDic = json["error"] as? Dictionary<String, AnyObject>, let errorMessage = errorDic["message"] as? String {
                    return QError.standard(reason: errorMessage)
                }
            }

        } catch {
            return error as NSError
        }
        
        guard error == nil else {
            return error
        }
        
        return nil
    }
}

