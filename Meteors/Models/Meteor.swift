//
//  Meteor.swift
//  Meteors
//
//  Created by bhuvan on 07/08/2021.
//

import Foundation

/// Tyoe of Meteorite.
enum MeteorType: String, Codable {
    case valid = "Valid"
    case relict = "Relict"
}

/// Tyoe of Meteor Fall.
enum FallType: String, Codable {
    case found = "Found"
    case fell = "Fell"
}

class Meteor: Codable {
    var id: String
    var name: String
    var type: MeteorType
    var meteorClass: String
    var year: String = ""
    var mass: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var fall: FallType
    
    /// Returns meteor year in integer.
    var yearValue: Double {
        return Double(year.prefix(4)) ?? 0
    }
    
    /// Returns mass of the meteor in integer.
    var massValue: Double {
        return Double(mass) ?? 0
    }
    
    /// Use to mark as favourites.
    var isFavourites: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "nametype"
        case meteorClass = "recclass"
        case year = "year"
        case mass = "mass"
        case latitude = "reclat"
        case longitude = "reclong"
        case fall = "fall"
        case isFavourites = "isFavourites"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.type = try container.decode(MeteorType.self, forKey: .type)
        self.meteorClass = try container.decode(String.self, forKey: .meteorClass)
        self.fall = try container.decode(FallType.self, forKey: .fall)
        self.isFavourites = try container.decodeIfPresent(Bool.self, forKey: .isFavourites) ?? false
        
        // NOTE:
        // Had to use this optional binding approach for few variables because the API
        // response is not consistent The nasa API sometimes returns the following
        // variables as strings and sometimes as Int/Double so the logic below
        // will handle both the cases and successfully encode the response.
        if let mass = try? container.decode(String.self, forKey: .mass) {
            self.mass = mass
        } else if let mass = try? container.decode(Int.self, forKey: .mass) {
            self.mass = "\(mass)"
        } else {
            self.mass = "N/A"
        }
        
        if let year = try? container.decode(String.self, forKey: .year) {
            self.year = year
        } else if let year = try? container.decode(Int.self, forKey: .year) {
            self.year = "\(year)"
        }
        
        if let latitude = try? container.decode(String.self, forKey: .latitude) {
            self.latitude = latitude
        } else if let latitude = try? container.decode(Double.self, forKey: .latitude) {
            self.latitude = "\(latitude)"
        }
        
        if let longitude = try? container.decode(String.self, forKey: .longitude) {
            self.longitude = longitude
        } else if let longitude = try? container.decode(Double.self, forKey: .longitude) {
            self.longitude = "\(longitude)"
        }
    }
}

extension Meteor {
    /// Find and update the selected meteor in the user defaults.
    func updateSavedMeteorList() {
        // Update the meteor
        let savedMeteors = MeteorViewModel().getSavedMeteors()
        savedMeteors.forEach { loopMeteor in
            if loopMeteor.id == self.id {
                loopMeteor.isFavourites = self.isFavourites
                return
            }
        }
        
        // Save the updated list
        MeteorViewModel().save(meteors: savedMeteors)
    }
}
