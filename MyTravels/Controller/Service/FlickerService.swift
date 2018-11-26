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

    func downloadPhoto(photoUrl: String,
                       success: @escaping (Data?) -> Void,
                       failure: @escaping (_ error: ServiceError) -> Void,
                       completed: @escaping ()-> Void) {
        ServiceManager.sharedInstance().request(url: photoUrl, method: .get,
                                                success: { (data) in
                                                    success(data)
        }, failure: { (error) in
            failure(error)
        }, completion: {
            completed()
        })
    }
}
