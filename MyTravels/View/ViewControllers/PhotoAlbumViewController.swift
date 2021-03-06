//
//  PhotoAlbumViewController.swift
//  MyTravels
//
//  Created by Rafael Cunha on 09/11/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let photoCellIdentifier = "photoCell"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!

    private var currentPage = 1
    private var numberOfPages = 0
    private var maxPhotosPerPage = 36
    
    var pointPin = PinPointAnnotation()
    var photoList = [Photo]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        // Start download photos
        if pointPin.pin!.photo?.count == 0 {
            getPhotos()
        } else {
            Loading.shared.hideLoading()
            photoList = Array(pointPin.pin!.photo!) as! [Photo]
            collectionView.reloadData()
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func btnNewCollection_Clicked(_ sender: UIButton) {
        for photo in photoList {
            pointPin.pin!.removeFromPhoto(photo)
        }
        photoList.removeAll()
        collectionView.reloadData()
        getPhotos()
    }
    
    // MARK: - Services
    
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
        
        FlickerService.sharedInstance().getPhotosByLocation(latitude: pin.latitude,
                                                            longitude: pin.longitude,
                                                            page: randomPage,
                                                            perPage: imagesPerPage, success:{ (responsePayload) in
                                                                DispatchQueue.main.async {
                                                                    Loading.shared.hideLoading()
                                                                    self.photoList = JSONResponse.deserializePhotos(dict: responsePayload, pointPin: self.pointPin)
                                                                    self.collectionView.reloadData()
                                                                }
        }, failure: {(error) in
            Loading.shared.hideLoading()
            AlertHelper.showGenericError()
        }, completed: {
            Loading.shared.hideLoading()
        })
    }
    
    // MARK: - Misc
    
    func setupMap() {
        mapView.addAnnotation(pointPin)
        let center = CLLocationCoordinate2D(latitude: pointPin.coordinate.latitude, longitude: pointPin.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCollectionViewCell", for: indexPath) as! LocationCollectionViewCell
        
        cell.setup(photo: photoList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension PhotoAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        AlertHelper.show(message: "Are you sure you want to delete the image?",
                         buttons: ["Confirm", "Cancel"], tapHandler: {(index) in
                            if index == 0 {
                                let photo = (collectionView.cellForItem(at: indexPath) as! LocationCollectionViewCell).photo!
                                self.pointPin.pin!.removeFromPhoto(photo)
                                CoreDataStack.sharedInstance?.context.delete(photo)
                                self.photoList.remove(at: indexPath.row)
                                
                                DispatchQueue.main.async {
                                    CoreDataStack.sharedInstance?.save()
                                }
                                
                                self.collectionView.reloadData()
                            } else {
                                print("Canceled")
                            }
        })
    }
}

extension PhotoAlbumViewController: UICollectionViewDelegateFlowLayout {
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
