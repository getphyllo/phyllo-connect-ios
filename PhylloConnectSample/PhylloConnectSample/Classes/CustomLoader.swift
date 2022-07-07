//
//  CustomLoader.swift
//  PhylloConnectSample
//
//  Created by Pankaj Patel on 29/12/21.
//

import Foundation
import UIKit
extension UIViewController {

    func showActivityIndicator() {
        
        let activityIndicator = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = .white
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = view.center
        activityIndicator.dropShadow()
        //activityIndicator.hidesWhenStopped = true
        let spinner = SpinnerView(frame: CGRect(x: activityIndicator.frame.width/2, y: activityIndicator.frame.height/2, width: 42, height: 42))
        spinner.center = CGPoint(x: activityIndicator.frame.size.width  / 2,
                                 y: activityIndicator.frame.size.height / 2)
        activityIndicator.tag = 100 // 100 for example
        activityIndicator.addSubview(spinner)
        // before adding it, you need to check if it is already has been added:
        for subview in view.subviews {
            if subview.tag == 100 {
                print("already added")
                return
            }
        }

        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }

    func hideActivityIndicator() {
        view.isUserInteractionEnabled = true
        let activityIndicator = view.viewWithTag(100)
        activityIndicator?.removeFromSuperview()
    }
}
