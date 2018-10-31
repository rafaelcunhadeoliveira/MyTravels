//
//  AlertHelper.swift
//  MyTravels
//
//  Created by Rafael Cunha de Oliveira on 30/10/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {

    class var shared: AlertHelper {
        struct Static {
            static let instance: AlertHelper = AlertHelper()
        }
        return Static.instance
    }

    func showBasicDialog(error: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            let alert = UIAlertController(title: "Ops, Something went wrong", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
