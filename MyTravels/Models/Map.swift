//
//  Map.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 26/09/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit

class Map: NSObject {
    
    static var latitude: Double {
        get {
            return UserDefaults.standard.double(forKey: "latitude")
        } set {
            UserDefaults.standard.set(newValue, forKey: "latitude")
        }
    }
    
    static var longitude: Double {
        get {
            return UserDefaults.standard.double(forKey: "longitude")
        } set {
            UserDefaults.standard.set(newValue, forKey: "longitude")
        }
    }
    
    static var latitudeDelta: Double {
        get {
            return UserDefaults.standard.double(forKey: "latitudeDelta")
        } set {
            UserDefaults.standard.set(newValue, forKey: "latitudeDelta")
        }
    }
    
    static var longitudeDelta: Double {
        get {
            return UserDefaults.standard.double(forKey: "longitudeDelta")
        } set {
            UserDefaults.standard.set(newValue, forKey: "longitudeDelta")
        }
    }

}
