//
//  MeteorViewModel.swift
//  Meteors
//
//  Created by bhuvan on 07/08/2021.
//

import Foundation

class MeteorViewModel {
    
    // MARK: - Constants
    private let kMeteorUserDefaultKey = "meteors"
    
    // MARK: - Properties
    internal var selectedSortByCategory: Int?
    internal var selectedFilterModel: FilterModel?
    internal var refreshAlertTitle: String {
        return "Important"
    }
    internal var refreshAlertMessage: String {
        return "This will reset your favourite list. Would you still like to continue and refresh meteor list?"
    }
    internal var refreshAlertYesAction: String {
        return "Yes"
    }
    internal var refreshAlertNoAction: String {
        return "No"
    }
    
    // MARK: - Placeholder Text
    internal func getPlaceholderText(_ selectedSegmentIndex: Int) -> String {
        if selectedSegmentIndex == 0 {
            return "No meteor found. Please try again."
        } else {
            return "No favourites.\nPress ♡ icon in the list to add here."
        }
    }
    
    // MARK: - Meteor List
    fileprivate func applyFilterOnMeteorList(_ savedMeteors: inout [Meteor]) {
        // Filtered meteors
        // Acceptance Criteria - Should filtered from the year 1990
        savedMeteors = savedMeteors.filter({ $0.yearValue >= 1990 })
        
        // Filter by year range
        if let selectedFilterModel = selectedFilterModel {
            savedMeteors = savedMeteors.filter({ $0.yearValue >= selectedFilterModel.lowerYear && $0.yearValue <= selectedFilterModel.upperYear })
        }
        // Filter by mass range
        if let selectedFilterModel = selectedFilterModel {
            savedMeteors = savedMeteors.filter({ $0.massValue >= selectedFilterModel.lowerMass && $0.massValue <= selectedFilterModel.upperMass })
        }
    }
    
    fileprivate func applySortingOnMeteorList(_ savedMeteors: inout [Meteor]) {
        // Sort by meteors
        if let selectedSortByCategory = self.selectedSortByCategory {
            switch selectedSortByCategory {
            case SortByCategory.name.rawValue:
                savedMeteors = savedMeteors.sorted(by: { $0.name < $1.name })
            case SortByCategory.id.rawValue:
                savedMeteors = savedMeteors.sorted(by: { Int($0.id) ?? 0 < Int($1.id) ?? 0 })
            case SortByCategory.type.rawValue:
                savedMeteors = savedMeteors.sorted(by: { $0.type.rawValue < $1.type.rawValue })
            case SortByCategory.meteorClass.rawValue:
                savedMeteors = savedMeteors.sorted(by: { $0.meteorClass < $1.meteorClass })
            case SortByCategory.mass.rawValue:
                savedMeteors = savedMeteors.sorted(by: { $0.massValue < $1.massValue })
            case SortByCategory.yearLowToHigh.rawValue:
                savedMeteors = savedMeteors.sorted(by: { $0.yearValue < $1.yearValue })
            case SortByCategory.yearHighToLow.rawValue:
                savedMeteors = savedMeteors.sorted(by: { $0.yearValue > $1.yearValue })
            default:
                break
            }
        }
    }
        
    /// Configure the final list of meteors to be displayed in the table view.
    /// - Parameter selectedSegmentIndex: Segment index to which list will be filtered.
    /// - Returns: Returns meteors list after filtering & sorting.
    func getMeteors(for selectedSegmentIndex: Int) -> [Meteor] {
        
        // All meteors
        var savedMeteors = getSavedMeteors()
        if selectedSegmentIndex == 1 {
            // Favourites meteors
            savedMeteors = savedMeteors.filter({ $0.isFavourites })
        }
        
        // Apply filter
        applyFilterOnMeteorList(&savedMeteors)
        
        // Apply sorting
        applySortingOnMeteorList(&savedMeteors)
        
        return savedMeteors
    }
}

// MARK: - Network Requests
extension MeteorViewModel {
    
    /// Fetch the meteors from the public API.
    /// - Parameter completion: Returns array of meteors.
    internal func fetchMeteors(completion: @escaping () -> Void) {
        
        // Create the meteor URL
        let urlString = "https://data.nasa.gov/resource/y77d-th95.json"
        let meteorListURL = URL(string: urlString)!
        
        // Create data task
        let dataTask = URLSession.shared.dataTask(with: meteorListURL) { data, response, error in
            // Parse the response and returns array of 'Meteor' type.
            guard
                error == nil,
                let responseData = data,
                let meteors = try? JSONDecoder().decode([Meteor].self, from: responseData) else {
                completion()
                return
            }
            
            // Save in defaults
            self.save(meteors: meteors)
            completion()
        }
        
        // Start data task
        dataTask.resume()
    }
}

// MARK: - Save/Get Meteors
extension MeteorViewModel {
    
    /// This will encode and save the provided meteors into the user defaults.
    /// - Parameter meteors: List of meteors.
    internal func save(meteors: [Meteor]) {
        
        // Create encoder
        let encoder = JSONEncoder()
        
        // Save data
        if let meteorData = try? encoder.encode(meteors) {
            UserDefaults.standard.set(meteorData, forKey: kMeteorUserDefaultKey)
        }
    }
    
    
    /// Decodes the meteor list from the user defaults.
    /// - Returns: Returns list of meteors.
    internal func getSavedMeteors() -> [Meteor] {
        
        // Create decoder
        let decoder = JSONDecoder()

        // Decode saved data in defaults
        guard
            let meteorData = UserDefaults.standard.data(forKey: kMeteorUserDefaultKey),
            let meteors = try? decoder.decode([Meteor].self, from: meteorData) else {
            return [Meteor]()
        }
        return meteors
    }
}
