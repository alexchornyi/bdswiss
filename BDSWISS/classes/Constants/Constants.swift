//
//  Constants.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import UIKit
import SwiftUI
import RxCocoaRuntime

// MARK: Constants

// MARK: - SERVER -

let serverURL = "https://pricing-staging.unleashedcapital.com"

// MARK: - Request -

enum Path: String {
    case rates = "rates"
}

// MARK: - Timer -

let timeInSec = 10.0


// MARK: - Font -

let fontAwesome = Font.custom("FontAwesome6Free-Solid", size: 20)
let textFont = Font.system(size: 14)
let iconConnection = "\u{01F30E}"
let iconNext = "\u{f0da}"
let iconDown = "\u{f0d7}"
let iconUp = "\u{f0d8}"
let iconUpDown = "\u{f0dc}"


// MARK: - Texts -

let textLoading = "Loading please wait..."


// MARK: - Colors -

enum Colors: Int {
    case green = 0
    case red = 1
    case black = 2
}

