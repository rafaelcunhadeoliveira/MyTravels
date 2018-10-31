//
//  ViewControllerExtension.swift
//  OnTheMap
//
//  Created by Rafael Cunha de Oliveira on 29/10/18.
//  Copyright © 2018 Rafael Cunha. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        view.frame.origin.y = 0
    }
}
