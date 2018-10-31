//
//  MKMapExtension.swift
//  MyTravels
//
//  Created by Rafael Cunha on 31/10/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import Foundation
import MapKit

extension UIViewController : MKMapViewDelegate {
    public var isEditing: Bool {
        get{ return isEditing }
        set(newValue) { self.isEditing = newValue }
    }

    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if isEditing {
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
