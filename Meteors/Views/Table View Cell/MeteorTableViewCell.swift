//
//  MeteorTableViewCell.swift
//  Meteors
//
//  Created by bhuvan on 07/08/2021.
//

import UIKit

protocol MeteorTableViewCellDelegate {
    func reload(cell: MeteorTableViewCell)
}

class MeteorTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var idButton: UIButton!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Properties
    internal static let identifier = "MeteorCellIdentifier"
    internal var meteor: Meteor?
    internal var delagate: MeteorTableViewCellDelegate?

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        setupAppearence()
    }
    
    // MARK: - Update Views
    fileprivate func setupAppearence() {
        
        // Override light mode
        overrideUserInterfaceStyle = .light

        // Card view
        cardView
            .corner(radius: 20.0)
            .border(width: 0.2,
                    color: .lightGray)
            .shadow(radius: 2,
                    opacity: 0.3,
                    offset: CGSize(width: 0, height: 1.5))
        
        // Meteor ID button
        idButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        idButton
            .border(width: 1.0, color: .systemGray4)
            .corner(radius: 10.0)
        idButton.imageView?.contentMode = .scaleAspectFill
    }
    
    /// Update the views using a meteor object.
    internal func updateView() {
        guard let meteor = meteor else { return }
        nameLabel.text = meteor.name
        yearLabel.text = "\(meteor.fall.rawValue) Year: \(Int(meteor.yearValue))"
        typeLabel.text = meteor.type.rawValue
        classLabel.text = meteor.meteorClass
        massLabel.text = meteor.mass
        idButton.setTitle("ID: \(meteor.id)", for: .normal)
        updateFavouriteButton()
    }
    
    /// Configure favourite button image.
    internal func updateFavouriteButton() {
        guard let meteor = meteor else { return }
        if meteor.isFavourites {
            favouriteButton.setImage(ImageConstants.heartFill, for: .normal)
        } else {
            favouriteButton.setImage(ImageConstants.heart, for: .normal)
        }
    }
     
    // MARK: - Button Actions
    @IBAction func favouriteButtonPressed(_ sender: Any) {        
        meteor!.isFavourites = !meteor!.isFavourites
        
        // Update button image
        updateFavouriteButton()
        
        // Updated the meteor in the saved list in user defaults
        meteor!.saveAndUpdateUserDefaults()
        
        // Reload table view cell to remove from the list
        delagate?.reload(cell: self)
    }    
}
