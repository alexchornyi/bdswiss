//
//  UITableView+.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import UIKit

extension UITableView {
    func setNoDataPlaceholder(_ message: String) {
        let label = UILabel(frame: CGRect(x: .zero, y: .zero, width: self.bounds.size.width, height: self.bounds.size.height))
        label.text = message
        label.textAlignment = .center
        label.textColor = .gray
        // styling
        label.sizeToFit()
        
        backgroundView = label
    }
    
    func removeNoDataPlaceholder() {
        backgroundView = nil
    }

}
