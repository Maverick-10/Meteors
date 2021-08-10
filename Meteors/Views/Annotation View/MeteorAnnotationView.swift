//
//  MeteorAnnotationView.swift
//  Meteors
//
//  Created by bhuvan on 08/08/2021.
//

import MapKit

class MeteorAnnotationView: MKMarkerAnnotationView {
    
    static let identifier = "meteorIdentifier"
    
    /// Perform early customize of the annotation.
    override var annotation: MKAnnotation? {
        willSet {
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
        }
    }
}

// MARK: -  Update Views
extension MeteorAnnotationView {
    
    /// Configure annotation view using meteor detail.
    func updateView(from meteor: Meteor) {
        
        // Create accesory view
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        let coordinateText = "(\(meteor.latitude)°, \(meteor.longitude)°)"
        let arrangedSubviews = [
            configLabelView(text: meteor.name, fontSize: 17.0, weight: .semibold, color: .darkGray),
            configLabelView(text: "\(meteor.fall.rawValue) in \(Int(meteor.yearValue)) at \(coordinateText)"),
            configLabelView(text: "ID: \(meteor.id)"),
            configLabelView(text: "Class: \(meteor.meteorClass)"),
            configLabelView(text: "Type: \(meteor.type.rawValue)")
        ]
        
        // Add labels in the stackview
        arrangedSubviews.forEach { subview in
            stackView.addArrangedSubview(subview)
        }
        
        // Update accessory view
        detailCalloutAccessoryView = stackView
    }
    
    /// Configure a label which will be used in mapview accessory view.
    func configLabelView(text: String, fontSize: CGFloat = 15.0, weight: UIFont.Weight = .regular, color: UIColor = .lightGray) -> UILabel {
        let textLabel = UILabel()
        textLabel.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        textLabel.text = text
        textLabel.textColor = color
        return textLabel
    }
}

