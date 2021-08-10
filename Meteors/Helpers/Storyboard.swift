//
//  Storyboard.swift
//  Meteors
//
//  Created by bhuvan on 08/08/2021.
//

import UIKit

extension UIViewController {
    
    /// Converts view controller class name into the string. Also the storyboard identifier in the storyboard should be same as view controller name.
    public static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

/// Contains all the storyboard in the project.
public enum Storyboard: String {
    case Main
    
    /// Instantiate the view controller for respective storyboard.
    /// - Parameter viewController: Type of the view controller.
    /// - Returns: Returns view controller with valid class type.
    public func instantiate<VC: UIViewController>(_ viewController: VC.Type) -> VC {
        guard let vc = UIStoryboard(name: self.rawValue, bundle: nil).instantiateViewController(withIdentifier: VC.storyboardIdentifier) as? VC else {
            fatalError("Couldn't instantiate \(VC.storyboardIdentifier) from \(self.rawValue)")
        }
        return vc
    }
}

