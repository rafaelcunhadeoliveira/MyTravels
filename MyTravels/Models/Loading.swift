//
//  Loading.swift
//  MyTravels
//
//  Created by Rafael Cunha de Oliveira on 30/10/18.
//  Copyright © 2018 Rafael Cunha de Oliveira. All rights reserved.
//

import Foundation
import UIKit

public class Loading {
    private var overView = UIView()
    private var load = UIActivityIndicatorView()

    class var shared: Loading {
        struct Static {
            static let instance: Loading = Loading()
        }
        return Static.instance
    }

    public func showLoading() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            configView(window: window, activate: false)
            buildOverWindow(window: window)
            buildActivityIndicator()
            overView.addSubview(load)
            window.rootViewController?.view.addSubview(overView)
            load.startAnimating()
        }
    }

    public func hideLoading() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let window = appDelegate.window {
            configView(window: window, activate: true)
            load.stopAnimating()
            overView.removeFromSuperview()
        }
    }

    private func configView(window: UIWindow, activate: Bool) {
        window.alpha = activate ? 1 : 0.7
        window.isUserInteractionEnabled = activate
    }

    private func buildOverWindow(window: UIWindow) {
        overView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        overView.center = window.center
        overView.backgroundColor = UIColor.black
        overView.clipsToBounds = true
        overView.layer.cornerRadius = 10
    }

    private func buildActivityIndicator() {
        load.frame = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        load.style = .whiteLarge
        load.center = CGPoint.init(x: overView.bounds.width/2, y: overView.bounds.height/2)
        load.hidesWhenStopped = true
    }
}
