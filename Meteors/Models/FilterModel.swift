//
//  FilterModel.swift
//  Meteors
//
//  Created by bhuvan on 09/08/2021.
//

import Foundation


internal struct FilterModel {
    var lowerYear: Double = 1990
    var upperYear: Double = 2021
    var lowerMass: Double = 0
    var upperMass: Double = 100000
    
    var yearDifference: Double {
        return upperYear - lowerYear
    }
    
    var massDifference: Double {
        return upperMass - lowerMass
    }
}
