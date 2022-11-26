//
//  Object+.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation
import RxCocoaRuntime

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
