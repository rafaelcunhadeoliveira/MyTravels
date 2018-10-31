//
//  MapViewController.swift
//  MyTravels
//
//  Created by Rafael Cunha de Oliveira on 31/10/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var editingView: UIView!
    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPinWhenTouch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isEditing = false
        editingView.isHidden = true
    }

    func configPinWhenTouch() {
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(self.handleTap(gestureReconizer:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @IBAction func editPins(_ sender: Any) {
        editingView.isHidden = self.isEditing
        self.isEditing = !self.isEditing
    }
    
    
    @objc func handleTap(gestureReconizer: UILongPressGestureRecognizer) {
        
        let location = gestureReconizer.location(in: map)
        let coordinate = map.convert(location,toCoordinateFrom: map)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
    }
}
