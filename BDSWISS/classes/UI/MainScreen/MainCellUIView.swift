//
//  MainCellUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 25.11.2022.
//

import SwiftUI

struct MainCell: View {

    private enum Constants {
        static let size = 40.0
        static let space = 16.0
        static let text = 20.0
        static let textWidth = 100.0
    }
    
    let rate: Rate
    @State var color = 2;
    @State var iconText: String = iconUpDown

    
    var body: some View {
        HStack {
            Image(uiImage: rate.firstFlag)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: Constants.size, maxWidth: Constants.size, minHeight: Constants.size, maxHeight: Constants.size)
            Spacer()
                .frame(width: Constants.space)
            Text(iconNext)
                .font(fontAwesome)
                .frame(width: Constants.text, alignment: .center)
            Spacer()
                .frame(width: Constants.space)
            Image(uiImage: rate.secondFlag)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: Constants.size, maxWidth: Constants.size, minHeight: Constants.size, maxHeight: Constants.size)
            Spacer()
                .frame(width: Constants.space)
            Text(rate.priceName)
                .foregroundColor(changeColor(color: color))
                .font(textFont)
                .frame(minWidth: Constants.textWidth, maxWidth: .infinity, alignment: .trailing)
            Text(iconText)
                .foregroundColor(changeColor(color: color))
                .font(fontAwesome)
                .frame(width: Constants.text, alignment: .trailing)
        }
        .onAppear {
            checkRate()
        }
    }
    
    func checkRate() {
        guard let symbol = rate.symbol, let oldValue = DataManager.shared.getOldRateFor(code: symbol) else {
            color = 2
            iconText = iconUpDown
            return
        }
        if rate.price > oldValue.price {
            color = 0
            iconText = iconUp
        }
        if rate.price < oldValue.price {
            color = 1
            iconText = iconDown
        }
        if rate.price == oldValue.price {
            color = 2
            iconText = iconUpDown
        }
    }
    
    func changeColor(color: Int) -> Color
    {
        switch color {
        case 0:
            return Color.green
        case 1:
            return Color.red
        default:
            return Color.black
        }
    }
}
