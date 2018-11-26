//
//  LocationCollectionViewCell.swift
//  MyTravels
//
//  Created by Rafael Cunha on 01/11/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    var photo: Photo?

    func setup(photo: Photo) {
        
        // Remove delegate from last Photo Object
        self.photo?.delegate = nil
        
        // Set the new Photo Object
        self.photo = photo
        self.photo?.delegate = self
        
        DispatchQueue.main.async {
            if photo.isDownloading || photo.image == nil {
                
                DispatchQueue.main.async {
                    Loading.shared.showLoading()
                    self.image.image = nil
                }
                
                photo.downloadPhoto()
                
            } else {
                
                DispatchQueue.main.async {
                    Loading.shared.hideLoading()
                    
                    guard let image = photo.downloadedImage else {
                        self.image.image = UIImage(data: photo.image! as Data)
                        return
                    }
                    
                    self.image.image = image
                }
            }
        }
    }
}

// MARK: PhotoDelegate
extension LocationCollectionViewCell: PhotoDelegate {
    func didFinishDownloadPhoto(photo: Photo) {
        setup(photo: photo)
    }
}

