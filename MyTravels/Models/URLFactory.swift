//
//  URLFactory.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 26/09/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class URLFactory {

    let key = "ebc6b3424d97c7e5cfbfd9d188715ecf"
    let baseUrl = "https://api.flickr.com/services/rest/"
    
    class func sharedInstance() -> URLFactory {
        struct Singleton {
            static var sharedInstance = URLFactory()
        }
        return Singleton.sharedInstance
    }

    func getFlickrUrlString(forMethod method: FlickerMethods) -> String {
        return (baseUrl + "?method=\(method.rawValue)&api_key=\(key)&format=json&nojsoncallback=1")
    }

    func buildURLFlickerLocation(latitude: Double,
                                 longitude: Double,
                                 page: Int,
                                 perPage: Int) -> String {
        return getFlickrUrlString(forMethod: .photosByLocation) + "&lat=\(latitude)&lon=\(longitude)&extras=url_m&per_page=\(perPage)&page=\(page)"
    }
}
