//
//  JSONResponse.swift
//  MyTravels
//
//  Created by Rafael Cunha on 10/10/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation

class JSONResponse {
    
    class func deserializePhotos(dict: [String: Any], pointPin: PinPointAnnotation) -> [Photo] {
        
        guard (dict["stat"] as? String) == "ok", let photos = dict["photos"] as? [String: Any] else { return [] }
        
        guard let total = photos["total"] as? Int, total > 0 else {
            return []
        }
        var photoList: [Photo] = []
        let maxPhotosPerPage = 36
        for item in photos["photo"] as! [[String: Any]] {
            if photoList.count == maxPhotosPerPage || photoList.count == total {
                break
            }
            let photo = Photo(context: CoreDataStack.sharedInstance!.context)
            photo.url = item["url_m"] as? String
            photo.pin = pointPin.pin!
            photoList.append(photo)
        }
        CoreDataStack.sharedInstance?.save()
        return photoList
    }

    class func deserialize(data: Data) -> AnyObject {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print("erro parse")
        }
        return "" as AnyObject
    }
}
