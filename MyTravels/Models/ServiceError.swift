//
//  ServiceError.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 09/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

struct ServiceError {

    var error: String?
    var code: String?
    
    init(dictionary: [String : AnyObject]) {
        self.error = dictionary["error"] as? String ?? ""
        self.code = dictionary["code"] as? String ?? ""
    }
    
    init(code: String, error: String) {
        self.code = code
        self.error = error
    }

    init() {
        self.init(code: "", error: "")
    }
}
