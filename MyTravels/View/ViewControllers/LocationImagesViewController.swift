//
//  LocationImagesViewController.swift
//  MyTravels
//
//  Created by Rafael Cunha on 31/10/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import UIKit
import MapKit

class LocationImagesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topImage: MKMapView!
    let photosList = [Photo]()
    private var currentPage = 1
    private var numberOfPages = 0
    private var maxPhotosPerPage = 20
    
    public var pointPin = PinPointAnnotation()
    var photoList = [Photo]()

    var delegate: UICollectionViewDelegateFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        if pointPin.pin!.photo?.count == 0 {
            getPhotos()
        } else {
            Loading.shared.showLoading()
            photoList = Array(pointPin.pin!.photo!) as! [Photo]
            collectionView.reloadData()
        }
    }

    func getPhotos() {
        
        DispatchQueue.main.async {
            Loading.shared.showLoading()
        }
        
        let pin = pointPin.pin!
        
        // Get a random page of images to fetch
        let imagesPerPage = 20
        let totalImages = 4000
        let totalPages: Int = totalImages / imagesPerPage
        let randomPage: Int = Int(arc4random_uniform(UInt32(totalPages)))
        
        photoList = []
        collectionView.reloadData()
        
        FlickerService.sharedInstance().getPhotosByLocation(latitude: pin.latitude,
                                                           longitude: pin.longitude,
                                                           page: randomPage,
                                                           perPage: imagesPerPage, success:{ (responsePayload) in
                                                            
                                                            DispatchQueue.main.async {
                                                                Loading.shared.hideLoading()
                                                            }
                                                    
                                                            
                                                            DispatchQueue.main.async {
                                                                self.getPhotosId(dict: responsePayload)
                                                                
                                                                if self.photoList.count == 0 {
                                                                    self.collectionView.isHidden = true
                                                                } else {
                                                                    self.collectionView.isHidden = false
                                                                    self.collectionView.reloadData()
                                                                }
                                                            }
        }, failure: {(error) in
            AlertHelper.shared.showBasicDialog(error: error.error ?? "error")
        }, completed: {})
    }

    func getPhotosId(dict: [String: Any]) {
        
        guard (dict["stat"] as? String) == "ok", let photos = dict["photos"] as? [String: Any] else {
            AlertHelper.shared.showBasicDialog(error: "Something went wrong")
            return
        }
        
        currentPage = photos["page"] as! Int
        numberOfPages = photos["pages"] as! Int
        
        guard let total = photos["total"] as? Int, total > 0 else {
            return
        }
        
        for item in photos["photo"] as! [[String: Any]] {
            
            if self.photoList.count == self.maxPhotosPerPage || self.photoList.count == total {
                break
            }
            
            
            let photo = Photo(context: CoreDataStack.sharedInstance!.context)
            photo.url = item["url_m"] as? String
            photo.pin = self.pointPin.pin!
            
            self.photoList.append(photo)
        }
        
        CoreDataStack.sharedInstance?.save()
    }

    func setupMap() {
        
        // Add pin to map
        topImage.addAnnotation(pointPin)
        
        // Set map zoom region
        let center = CLLocationCoordinate2D(latitude: pointPin.coordinate.latitude, longitude: pointPin.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        topImage.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }

    @IBAction func newCollectionButton(_ sender: Any) {
    }

}

extension LocationImagesViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: "Are you sure you want to delete the image?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { (action) in
            let photo = (collectionView.cellForItem(at: indexPath) as! LocationCollectionViewCell).photo!
            self.pointPin.pin!.removeFromPhoto(photo)
            CoreDataStack.sharedInstance?.context.delete(photo)
            self.photoList.remove(at: indexPath.row)
            
            DispatchQueue.main.async {
                CoreDataStack.sharedInstance?.save()
            }
            
            self.collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension LocationImagesViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as? LocationCollectionViewCell else { return UICollectionViewCell() }
        cell.setup(photo: photosList[indexPath.row])
        return cell
    }
}

extension LocationImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

