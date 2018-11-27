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

    private class var shared: AlertHelper {
        struct Static {
            static let instance: AlertHelper = AlertHelper()
        }
        return Static.instance
    }
    
    var tapHandler: ((Int) -> Void)? = nil

    static func showGenericError() {
        AlertHelper.shared.show(tapHandler: {_ in})
    }
    
    static func show(title: String = "",
                     message: String = "",
                     buttons: [String] = [],
                     tapHandler: @escaping (Int) -> Void) {
        AlertHelper.shared.show(title: title, message: message,
                                buttons: buttons, tapHandler: tapHandler)
    }

    private func show(title: String = "Ops, somethins went wrong",
                      message: String = "Try again later",
                      buttons: [String] = ["OK"],
                      tapHandler: @escaping (Int) -> Void) {
        self.tapHandler = tapHandler
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for (index, button) in buttons.enumerated() {
            let action = UIAlertAction(title: button, style: .default, handler: { [weak self] _ in
                guard let handler = self?.tapHandler else { return }
                handler(index)
            })
            alertController.addAction(action)
        }
        let controller = UIApplication.shared.keyWindow?.rootViewController
        controller?.present(alertController, animated: false)
    }
}

