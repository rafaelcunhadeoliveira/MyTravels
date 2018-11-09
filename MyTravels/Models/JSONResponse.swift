//
//  JSONResponse.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 10/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class JSONResponse {
    class func deserialize(data: Data) -> AnyObject {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print("erro parse")
        }
        return "" as AnyObject
    }
}
