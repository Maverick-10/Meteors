//
//  SortMeteorViewController.swift
//  Meteors
//
//  Created by bhuvan on 07/08/2021.
//

import UIKit

enum SortByCategory: Int {
    case name = 1, id, type, meteorClass, mass, yearLowToHigh, yearHighToLow
}

protocol SortByCategoryDelegate {
    func sortByCategory(category: Int)
}

class SortMeteorViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var idButton: UIButton!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var classButton: UIButton!
    @IBOutlet weak var massButton: UIButton!
    @IBOutlet weak var yearLowToHighButton: UIButton!
    @IBOutlet weak var yearHighToLowButton: UIButton!
    
    // MARK: - Properties
    internal var delegate: SortByCategoryDelegate?
    internal var selectedSortByCategory: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup initial appearence
        setupAppearence()
        
        // Add tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateViewFromTheBottom()
    }
    
    // MARK: - Setup views
    /// Setup all the initial appearence here.
    fileprivate func setupAppearence() {
        
        // Set initial state of the views
        view.alpha = 0
        
        // Update Constraint
        bottomConstraint.constant = -(view.bounds.size.height * 0.5)
        
        // Update button title
        let selectedFont = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        if let selectedSortByCategory = self.selectedSortByCategory {
            switch selectedSortByCategory {
            case SortByCategory.name.rawValue:
                nameButton.titleLabel?.font = selectedFont
            case SortByCategory.id.rawValue:
                idButton.titleLabel?.font = selectedFont
            case SortByCategory.type.rawValue:
                typeButton.titleLabel?.font = selectedFont
            case SortByCategory.meteorClass.rawValue:
                classButton.titleLabel?.font = selectedFont
            case SortByCategory.mass.rawValue:
                massButton.titleLabel?.font = selectedFont
            case SortByCategory.yearLowToHigh.rawValue:
                yearLowToHighButton.titleLabel?.font = selectedFont
            case SortByCategory.yearHighToLow.rawValue:
                yearHighToLowButton.titleLabel?.font = selectedFont
            default:
                break
            }
        }
    }
    
    /// Dismiss the view.
    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Sort Animation
    /// Animates the filter view from the bottom
    fileprivate func animateViewFromTheBottom() {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.bottomConstraint.constant = 8
            self.view.layoutIfNeeded()
        } completion: { _ in }
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func sortCategoryButtonPressed(_ sender: UIButton) {
        dismiss(animated: false) {
            self.delegate?.sortByCategory(category: sender.tag)
        }
    }
}
