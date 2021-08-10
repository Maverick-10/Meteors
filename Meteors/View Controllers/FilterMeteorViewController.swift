//
//  FilterMeteorViewController.swift
//  Meteors
//
//  Created by bhuvan on 07/08/2021.
//

import UIKit

protocol FilterByDelegate {
    func filterBy(_ filterModel: FilterModel)
}


class FilterMeteorViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var massSlider: RangeSlider!
    @IBOutlet weak var yearSlider: RangeSlider!
    @IBOutlet weak var massRangeLabel: UILabel!
    @IBOutlet weak var yearRangeLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    // MARK: - Properties
    internal var delegate: FilterByDelegate?
    internal var selectedFilterModel: FilterModel?
    fileprivate let defaultModel = FilterModel()
    
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
    
    // MARK: - Setup Views
    /// Setup all the initial appearence here.
    fileprivate func setupAppearence() {
        
        // Set initial state of the views
        view.alpha = 0
        bottomConstraint.constant = -(view.bounds.size.height * 0.5)
        
        // Update selected Filter
        if let selectedFilterModel = selectedFilterModel {
            yearSlider.lowerValue = (selectedFilterModel.lowerYear  - defaultModel.lowerYear) / defaultModel.yearDifference
            yearSlider.upperValue = (selectedFilterModel.upperYear  - defaultModel.lowerYear) / defaultModel.yearDifference
            massSlider.lowerValue = (selectedFilterModel.lowerMass  - defaultModel.lowerMass) / defaultModel.massDifference
            massSlider.upperValue = (selectedFilterModel.upperMass  - defaultModel.lowerMass) / defaultModel.massDifference
        }
        
        // Update year and mass range
        updateYearRangeLabel()
        updateMassRangeLabel()
    }
    
    /// Dismiss the view.
    @objc func dismissView() {
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Actions
    @IBAction func applyButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            let filterModel = FilterModel(lowerYear: self.getYearRange().0,
                                          upperYear: self.getYearRange().1,
                                          lowerMass: self.getMassRange().0,
                                          upperMass: self.getMassRange().1)
            self.delegate?.filterBy(filterModel)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissView()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.filterBy(self.defaultModel)
        }
    }
    
    // MARK: - Filter Animation
    /// Animates the filter view from the bottom
    fileprivate func animateViewFromTheBottom() {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.bottomConstraint.constant = 8
            self.view.layoutIfNeeded()
        } completion: { isSuccess in
        }
    }
    
    // MARK: - Year/Mass Slider Actions
    @IBAction func yearSliderAction(_ sender: Any) {
        updateYearRangeLabel()
    }
    
    @IBAction func massSliderAction(_ sender: Any) {
        updateMassRangeLabel()
    }
}

// MARK: - Update Views
extension FilterMeteorViewController {
    
    /// Returns the lower and upper range from the year slider.
    fileprivate func getYearRange() -> (Double, Double) {
        let defaultModel = FilterModel()
        let lowerYear = (yearSlider.lowerValue * defaultModel.yearDifference) + defaultModel.lowerYear
        let upperYear = (yearSlider.upperValue * defaultModel.yearDifference) + defaultModel.lowerYear
        return (lowerYear, upperYear)
    }
    
    /// Returns the lower and upper range from the mass slider.
    fileprivate func getMassRange() -> (Double, Double) {
        let defaultModel = FilterModel()
        let lowerMass = (massSlider.lowerValue * defaultModel.massDifference) + defaultModel.lowerMass
        let upperMass = (massSlider.upperValue * defaultModel.massDifference) + defaultModel.lowerMass
        return (lowerMass, upperMass)
    }
    
    /// Updates year label with the selected range.
    fileprivate func updateYearRangeLabel() {
        yearRangeLabel.text = "\(Int(getYearRange().0)) - \(Int(getYearRange().1))"
    }
    
    /// Updates mass label with the selected range.
    fileprivate func updateMassRangeLabel() {
        massRangeLabel.text = "\(Int(getMassRange().0)) - \(Int(getMassRange().1))"
    }
}
