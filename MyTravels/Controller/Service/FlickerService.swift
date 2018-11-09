//
//  FlickerService.swift
//  MyTravels
//
//  Created by Rafael Cunha on 09/11/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import Foundation

class FlickerService {
    class func sharedInstance() -> FlickerService {
        struct Singleton {
            static var sharedInstance = FlickerService()
        }
        return Singleton.sharedInstance
    }

    
}
