//
//  LoaderViewController.swift
//  Meteors
//
//  Created by bhuvan on 08/08/2021.
//

import UIKit


class LoaderViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var activityIndicatorContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorContainer.corner(radius: 20.0)
    }
}
