//
//  PriceReporter.swift
//  BCForward_DSW
//
//  Created by Rave Bizz on 7/28/22.
//

import Foundation

struct PriceReporter {
    
    typealias Products = (normal: [Product], onClearance: [Product])
    typealias Report = (products: [Product], types: [ItemType])
    
    private var cartArr: [Product] = []
    
    private var maxClearancePrice: Double?
    private var minClearancePrice: Double?
    private var minNormalPrice: Double?
    
    mutating func generate() -> String {
        let reportData: Report = decodeData(input: fetchData())
        let products: Products = categorizeProducts(products: reportData.products)
        populateNormalPriceInfo(normalProducts: products.normal)
        populateClearanceInfo(clearanceProducts: products.onClearance)
        return generateReport(clearanceProducts: products.onClearance, normalProducts: products.normal)
    }
    
    private func decodeData(input: String) -> ([Product],[ItemType]) {
        let data = input.split(whereSeparator: \.isNewline).map { $0.components(separatedBy: ",") }
        var productArr = [Product]()
        var typeArr = [ItemType]()
        for type in data {
            if type[0] == TypeString.product.rawValue {
                let product = Product(normalPrice: Double(type[1])!, clearancePrice: Double(type[2])!, numInStock: Int(type[3])!, priceHidden: Bool(type[4])!)
                productArr.append(product)
            } else {
                let newType = ItemType(identificationKey: type[1], displayName: type[2])
                typeArr.append(newType)
            }
        }
        return (productArr, typeArr)
    }
    
    private func categorizeProducts(products: [Product]) -> ([Product], [Product]) {
        var normalArr = [Product]()
        var clearanceArr = [Product]()
        for product in products {
            if product.normalPrice == product.clearancePrice {
                normalArr.append(product)
            } else {
                clearanceArr.append(product)
            }
        }
        return (normalArr, clearanceArr)
    }
    
    private mutating func populateNormalPriceInfo(normalProducts: [Product]) {
        if normalProducts.count == 1 {
            minNormalPrice = normalProducts[0].normalPrice
        } else {
            let normalPrices = normalProducts.map { $0.normalPrice }.sorted(by: { $0 < $1})
            minNormalPrice = normalPrices[0]
        }
    }
    
    private mutating func populateClearanceInfo(clearanceProducts: [Product]) {
        if clearanceProducts.count == 1{
            minClearancePrice = clearanceProducts[0].clearancePrice
            maxClearancePrice = clearanceProducts[0].clearancePrice
        } else {
            let clearancePrices = clearanceProducts.map { $0.clearancePrice }.sorted(by: { $0 < $1 } )
            minClearancePrice = clearancePrices[0]
            maxClearancePrice = clearancePrices[clearancePrices.count - 1]
        }
    }
    
    private func generateReport(clearanceProducts: [Product], normalProducts: [Product]) -> String {
        let clearanceStr = clearanceProducts.count > 1 ? "$\(minClearancePrice!)-$\(maxClearancePrice!)" : "$\(clearanceProducts[0].clearancePrice)"
        let normalStr = normalProducts.count > 1 ? "$\(minNormalPrice!)-$\(minNormalPrice!)" : "$\(normalProducts[0].normalPrice)"
        
        let displayStr = "\(TypeString.clearance.rawValue): \(clearanceProducts.count) products @ \(clearanceStr)\n\(TypeString.normal.rawValue): \(normalProducts.count) product @ \(normalStr)\n\(TypeString.price_in_cart.rawValue): \(cartArr.count) products"
        
        return displayStr
    }
    
    private func fetchData() -> String {
        var result = ""
        
        let fileUrl = Bundle.main.path(forResource: "data", ofType: "txt")
        
        do {
            result = try String(contentsOf: NSURL.fileURL(withPath: fileUrl ?? ""))
        } catch {
            return error.localizedDescription
        }
        return result
    }
    
    private enum TypeString: String {
        case normal = "Normal Price"
        case clearance = "Clearance Price"
        case price_in_cart = "Price In Cart"
        case type = "Type"
        case product = "Product"
    }
}
