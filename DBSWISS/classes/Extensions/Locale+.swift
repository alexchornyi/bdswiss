//
//  Locale+.swift
//  DBSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation

extension Locale: CaseIterable {
    public static let allCases: [Locale] = availableIdentifiers.map(Locale.init(identifier:))
}

public extension Locale {
    init?(currencyCode: String) {
        guard let locale = Self.allCases.first(where: { $0.currencyCode == currencyCode }) else { return nil }
        self = locale
     }
}
