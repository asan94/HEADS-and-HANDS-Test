//
//  Error.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 03.07.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import Foundation
extension NSError {
    
    func errorWithDescriprionEndErrorCode(errorCode: Int, description: String) -> NSError {
        let userInfo: [AnyHashable : Any] = [NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: description, comment: "")]
        let error = NSError(domain: "ShiploopHttpResponseErrorDomain", code: errorCode, userInfo: userInfo)
        return error
    }
}
