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
    var context = NSManagedObjectContext()
    let entityName = "Pin"
    var savedPins: [NSManagedObject] = []
    

    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPinWhenTouch()
        self.setUpCoreData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isEditing = false
        editingView.isHidden = true
        getData()
    }

    // MARK: - Core Data

    func setUpCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
    }

    func createNewPin(coordinate: CLLocationCoordinate2D, name: String) -> NSManagedObject {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
            else { return NSManagedObject() }
        let newPin = NSManagedObject(entity: entity, insertInto: context)
        let latitude = Double(coordinate.latitude)
        let longitude = Double(coordinate.longitude)
        newPin.setValue(latitude, forKey: "latitude")
        newPin.setValue(longitude, forKey: "longitude")
        newPin.setValue(name, forKey: "name")
        return newPin
    }

    func saveData(newPin: NSManagedObject) {
        do {
            try context.save()
        } catch {
            AlertHelper.shared.showBasicDialog(error: "Error saving the pin")
        }
    }

    func getData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            guard let objs = result as? [NSManagedObject] else { return }
            self.savedPins = objs
            for data in objs {
                let coordinate = buildLocation2d(data: data)
                guard let name = data.value(forKey: "name") as? String
                    else { return }
                addAnnotation(coordinate: coordinate, name: name)
            }
        } catch {
            AlertHelper.shared.showBasicDialog(error: "Cannot fetch data")
        }
    }

    func removeObj(view: MKAnnotationView) {
        let latitude = Double(view.annotation?.coordinate.latitude ?? 0)
        let longitude = Double(view.annotation?.coordinate.longitude ?? 0)
        for obj in savedPins {
            if let objLatitude = obj.value(forKey: "latitude") as? Double,
                let objLongitude = obj.value(forKey: "longitude") as? Double{
                if objLatitude == latitude && objLongitude == longitude {
                    context.delete(obj)
                }
            }
        }
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

    func addAnnotation(coordinate: CLLocationCoordinate2D, name: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = name
        map.addAnnotation(annotation)
    }

    func getCityName(coordinate: CLLocationCoordinate2D) {
        let geoCoder = CLGeocoder()
        let location = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler:{(placemarks, _) in
            guard let placemarks = placemarks,
                  let location = placemarks.first,
                  let name = location.name else {
                    AlertHelper.shared.showBasicDialog(error: "Error searching location")
                    return
            }
            let pin = self.createNewPin(coordinate: coordinate, name: name)
            self.saveData(newPin: pin)
            self.addAnnotation(coordinate: coordinate, name: name)
        })
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
            getCityName(coordinate: coordinate)
        }
    }
}

extension MapViewController : MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if isEditing {
            self.removeObj(view: view)
            view.removeFromSuperview()
        } else {
            let viewController = UIStoryboard(name: "Main",
                                              bundle: nil).instantiateViewController(withIdentifier: "LocationImagesViewController")
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
}
