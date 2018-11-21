//
//  Constants.swift
//  OnTheMap
//
//  Created by Rafael Cunha on 26/09/2018.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import UIKit
import CoreData

protocol PhotoDelegate {
    func didFinishDownloadPhoto(photo: Photo)
}

@objc(Photo)
public class Photo: NSManagedObject {
    // MARK: - Properties
    
    var delegate: PhotoDelegate?
    var isDownloading = false
    var downloadedImage: UIImage?
    
    
    // MARK: - Service
    
    func downloadPhoto() {
        
        guard let url = url else {
            return
        }
        
        isDownloading = true
        
        FlickrService.sharedInstance().downloadPhoto(photoUrl: url) { (data, response, error) in
            
            guard let imgData = data, let image =  UIImage(data: imgData) else {
                return
            }
            
            DispatchQueue.main.async {
                
                self.image = data as NSData?
                self.downloadedImage = image
                self.isDownloading = false
                self.delegate?.didFinishDownloadPhoto(photo: self)
                
                CoreDataStack.sharedInstance?.save()
            }
        }
        
    }

}
