//
//  LoaderView.swift
//  Meteors
//
//  Created by bhuvan on 09/08/2021.
//

import UIKit


class LoaderView {
    
    /// Singleton instance.
    static let shared = LoaderView()
    
    /// Presented loader view controller.
    static var presentedVC: UIViewController?
    
    /// Shows animating activity indicator view.
    static func show() {
        let loaderVC = Storyboard.Main.instantiate(LoaderViewController.self)
        loaderVC.modalPresentationStyle = .overFullScreen
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let loaderView = loaderVC.view {
            loaderView.backgroundColor = .clear
            presentedVC = loaderVC
            appDelegate.window?.rootViewController?.present(loaderVC, animated: false, completion: nil)
        }
    }
    
    /// Dismisses the active loader view.
    static func dismiss() {
        presentedVC?.dismiss(animated: false, completion: nil)
    }
}
