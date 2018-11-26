//
//  EnvironmentVariables.swift
//  MyTravels
//
//  Created by Rafael Cunha on 09/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class EnvironmentVariables {
    
    // MARK: - init
    class func sharedInstance() -> EnvironmentVariables {
        struct Singleton {
            static var sharedInstance = EnvironmentVariables()
        }
        return Singleton.sharedInstance
    }
    let key = "ebc6b3424d97c7e5cfbfd9d188715ecf"
    let baseUrl = "https://api.flickr.com/services/rest/"
}
