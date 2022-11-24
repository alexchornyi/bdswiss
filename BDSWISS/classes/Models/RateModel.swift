//
//  RateModel.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import UIKit
import FlagKit

class Rate: Codable, Identifiable {
    var id = UUID()
    let symbol: String?
    var price: Double = 0.0
    var date = Date()
    
    var priceName: String {
        "\(price.rounded(toPlaces: 4))"
    }
    
    var firstFlag: UIImage {
        getImageFor(currency: symbol?.first(char: 3) ?? "USD")
    }

    var secondFlag: UIImage {
        getImageFor(currency: symbol?.last(char: 3) ?? "USD")
    }
    
    private enum CodingKeys: CodingKey {
        case symbol
        case price
    }
    
    func getImageFor(currency: String) -> UIImage {
        let localeComponents = Locale(currencyCode: currency)
        let locale = Locale(identifier: localeComponents?.identifier ?? "us")
        var countryCode = locale.regionCode!
        if countryCode == "EA" {
            countryCode = "EU"
        }
        let flag = Flag(countryCode: countryCode)!
        let styledImage = flag.image(style: .circle)
        return styledImage
    }

}
