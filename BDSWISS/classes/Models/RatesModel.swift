//
//  RatesModel.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation

class Rates: Codable {
    let rates: [Rate]?
    var date: Date = Date()
    
    private enum CodingKeys: CodingKey {
        case rates
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rates = try container.decodeIfPresent([Rate].self, forKey: .rates)
    }
}
