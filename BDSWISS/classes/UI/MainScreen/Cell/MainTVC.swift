//
//  MainTVC.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import UIKit
import FlagKit

class MainTVC: UITableViewCell {
    
    private enum Constants {
        static let textColor = UIColor(named: "textColor")
    }
    
    @IBOutlet private weak var mainFlagView: UIImageView!
    @IBOutlet private weak var secondFlagView: UIImageView!
    @IBOutlet private weak var iconLabel: UILabel!
    @IBOutlet private weak var rateLabel: UILabel!
    @IBOutlet weak var upDownLabel: UILabel!

    private var oldRate: Rate?
    private var rate: Rate? {
        didSet {
            setView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }
    
    private func setupView() {
        let countryCode = Locale.current.regionCode!
        let flag = Flag(countryCode: countryCode)!

        // Or retrieve a styled flag
        let styledImage = flag.image(style: .circle)
        mainFlagView.image = styledImage
        secondFlagView.image = styledImage
        iconLabel.font = iconFont
        upDownLabel.font = iconFont
        iconLabel.text = iconNext
        upDownLabel.text = iconUpDown
    }
    
    private func setView() {
        guard let rate = rate else {
            return
        }
        rateLabel.text = rate.priceName
        mainFlagView.image = rate.firstFlag
        secondFlagView.image = rate.secondFlag
        
        guard let oldRate = oldRate else {
            return
        }
        if rate.price > oldRate.price {
            upDownLabel.textColor = .green
            rateLabel.textColor = .green
            upDownLabel.text = iconUp
        }
        if rate.price < oldRate.price {
            upDownLabel.textColor = .red
            rateLabel.textColor = .red
            upDownLabel.text = iconDown
        }
        if rate.price == oldRate.price {
            upDownLabel.textColor = Constants.textColor
            rateLabel.textColor = Constants.textColor
            upDownLabel.text = iconUpDown
        }
    }
    
    func set(rate: Rate, oldRate: Rate? = nil) {
        self.oldRate = oldRate
        self.rate = rate
        
    }
}
