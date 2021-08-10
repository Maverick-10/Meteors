//
//  MeteorMapViewController.swift
//  Meteors
//
//  Created by bhuvan on 08/08/2021.
//

import UIKit
import MapKit

protocol MeteorMapDelegate {
    func reloadTableView()
}

class MeteorMapViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var favouriteButton: UIButton!
    
    // MARK: - Properties
    internal var meteor: Meteor!
    internal var delegate: MeteorMapDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set map delegate
        mapView.delegate = self
        
        // Update favourite button
        updateFavouriteButton()
        
        // Override light mode
        overrideUserInterfaceStyle = .light
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addAnnotation()
    }
    
    // MARK: - Update Views
    /// Configure favourite button image.
    internal func updateFavouriteButton() {
        if meteor.isFavourites {
            favouriteButton.setImage(ImageConstants.heartFill, for: .normal)
        } else {
            favouriteButton.setImage(ImageConstants.heart, for: .normal)
        }
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonPressed(_ sender: Any) {
        delegate?.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favouriteButtonPressed(_ sender: Any) {
        // Update meteor object
        meteor.isFavourites = !meteor.isFavourites
        
        // Update button image
        updateFavouriteButton()
        
        // Updated the saved list in the user defaults
        meteor.saveAndUpdateUserDefaults()
    }
}

// MARK: - Add Annotation
extension MeteorMapViewController {
    
    /// Add the meteor landing location with the annotation on the map view.
    fileprivate func addAnnotation() {
        guard
            let latitude = Double(meteor.latitude),
            let longitude = Double(meteor.longitude) else {
            return
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                longitude: location.coordinate.longitude);
        // Set Map region
        let offset: Double = 0.2
        let span = MKCoordinateSpan(latitudeDelta: mapView.region.span.latitudeDelta * offset,
                                    longitudeDelta: mapView.region.span.longitudeDelta * offset)
        print(mapView.region.span)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
    }
}

// MARK: - Mapview Delegate
extension MeteorMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // Configure annotation view
        var annotationView: MeteorAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: MeteorAnnotationView.identifier) as? MeteorAnnotationView {
        
            // Use the existing annotation view
            dequeuedView.annotation = annotation
            annotationView = dequeuedView
        } else {
            
            // Create the annotation view
            annotationView = MeteorAnnotationView(annotation: annotation, reuseIdentifier: MeteorAnnotationView.identifier)
            annotationView.updateView(from: meteor)
        }
        return annotationView
    }
}
