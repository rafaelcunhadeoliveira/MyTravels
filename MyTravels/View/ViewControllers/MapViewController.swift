//
//  MapViewController.swift
//  MyTravels
//
//  Created by Rafael Cunha de Oliveira on 31/10/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {

    @IBOutlet weak var editingView: UIView!
    @IBOutlet weak var map: MKMapView!
    let entityName = "Pin"
    var savedPins: [NSManagedObject] = []
    var pins = [Pin]()
    

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPinWhenTouch()
        loadLocations()
        loadLastRegion()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isEditing = false
        editingView.isHidden = true
    }

    func loadLocations() {
        var annotations = [MKAnnotation]()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        
        do {
            let results = try CoreDataStack.sharedInstance?.context.fetch(fetchRequest)
            pins.append(contentsOf: (results as! [Pin]))
        } catch {
            return
        }
        
        for pin in pins {
            let annotation = PinPointAnnotation()
            annotation.pin = pin
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(pin.latitude),longitude: CLLocationDegrees(pin.longitude))
            annotations.append(annotation)
        }
        
        map.addAnnotations(annotations)
        
        
    }
    
    func loadLastRegion() {
        
        if Map.latitude == 0 && Map.longitude == 0 && Map.latitudeDelta == 0 && Map.longitudeDelta == 0 {
            return
        }
        
        let center = CLLocationCoordinate2D(latitude: Map.latitude, longitude: Map.longitude)
        let span = MKCoordinateSpan(latitudeDelta: Map.latitudeDelta, longitudeDelta: Map.longitudeDelta)
        
        map.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }

    // MARK: - methods

    func buildLocation2d(data: NSManagedObject) -> CLLocationCoordinate2D{
        guard let latitudeDouble = data.value(forKey: "latitude") as? Double,
        let longitudeDouble = data.value(forKey: "longitude") as? Double
            else { return  CLLocationCoordinate2D()}
        let latitude = CLLocationDegrees.init(latitudeDouble)
        let longitude = CLLocationDegrees.init(longitudeDouble)
        return CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
    }

    func configPinWhenTouch() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(gestureReconizer:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        
        let annotation = PinPointAnnotation()
        annotation.coordinate = coordinate
        
        map.addAnnotation(annotation)
        
        let pin = Pin(context: CoreDataStack.sharedInstance!.context)
        pin.latitude = annotation.coordinate.latitude
        pin.longitude = annotation.coordinate.longitude
        
        annotation.pin = pin
        
        DispatchQueue.main.async {
            CoreDataStack.sharedInstance?.save()
        }
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
    }

    func removeAnnotation(view: MKAnnotationView) {
        view.removeFromSuperview()
        guard let lat = view.annotation?.coordinate.latitude,
            let lon = view.annotation?.coordinate.longitude else { return }
        for pin in pins {
            if pin.latitude == lat && pin.longitude == lon {
                CoreDataStack.sharedInstance?.context.delete(pin)
                CoreDataStack.sharedInstance?.save()
            }
        }
    }

    func goFoward(mapView: MKMapView) {
        guard let viewController = UIStoryboard(name: "Main",
                                                bundle: nil).instantiateViewController(
                                                    withIdentifier: "PhotoAlbumViewController")
            as? PhotoAlbumViewController else { return }
        
        guard mapView.selectedAnnotations.count > 0,
            let pin = mapView.selectedAnnotations[0] as? PinPointAnnotation else {
                return
        }
        viewController.pointPin = pin
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }

    // MARK: Actions

    @IBAction func editPins(_ sender: Any) {
        editingView.isHidden = self.isEditing
        self.isEditing = !self.isEditing
    }

    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        if !self.isEditing {
            let location = gestureReconizer.location(in: map)
            let coordinate = map.convert(location,toCoordinateFrom: map)
            addAnnotation(coordinate: coordinate)
        }
    }
}

extension MapViewController : MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if isEditing {
            removeAnnotation(view: view)
        } else {
            goFoward(mapView: mapView)
        }
    }
}
