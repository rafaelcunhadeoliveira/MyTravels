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

    func getPhotosByLocation(latitude: Double,
                             longitude: Double,
                             page: Int,
                             perPage: Int,
                             success: @escaping ([String : Any]) -> Void,
                             failure: @escaping (_ error: ServiceError) -> Void,
                             completed: @escaping ()-> Void) {
        let url = URLFactory.sharedInstance().buildURLFlickerLocation(latitude: latitude, longitude: longitude, page: page, perPage: perPage)
        
        ServiceManager.sharedInstance().request(url: url, method: .get,
                                                success: { (data) in
                                                    guard let response = JSONResponse.deserialize(data: data) as? [String : Any] else {
                                                        return
                                                    }
                                                    success(response)
        }, failure: { (error) in
            failure(error)
        }, completion: {
            completed()
        })
    }

    func downloadPhoto(photoUrl: String, onCompleted completed: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void) {
        let url = NSURL(string: photoUrl)
        let request = URLRequest(url: url! as URL)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){ data, response, error in
            completed(data, response, error)
        }
        task.resume()
    }
    
}
