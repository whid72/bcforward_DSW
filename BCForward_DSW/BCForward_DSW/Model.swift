//
//  Model.swift
//  BCForward_DSW
//
//  Created by Rave Bizz on 7/28/22.
//

import Foundation

struct ItemType {
    var identificationKey: String?
    var displayName: String?
    
    init(identificationKey: String, displayName: String){
        self.identificationKey = identificationKey
        self.displayName = displayName
    }
}

struct Product {
    var itemType: ItemType?
    var normalPrice: Double
    var clearancePrice: Double
    var numInStock: Int
    var priceHidden: Bool
    
    init(normalPrice: Double, clearancePrice: Double, numInStock: Int, priceHidden: Bool){
        self.normalPrice = normalPrice
        self.clearancePrice = clearancePrice
        self.numInStock = numInStock
        self.priceHidden = priceHidden
    }
    
}
