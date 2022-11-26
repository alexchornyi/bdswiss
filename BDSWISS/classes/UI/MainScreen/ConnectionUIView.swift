//
//  ConnectionUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 25.11.2022.
//

import SwiftUI
import RxSwift

struct ConnectionView: View {
    
    enum Status: String {
        case online = "online"
        case offline = "ofline"
    }
    
    private enum Constants {
        static let width = 50.0
        static let space = 4.0
        static let stackHeight = 40.0
    }
    private let disposeBag = DisposeBag()

    @State var color = 0;
    @State var connectionText: String = Status.online.rawValue
    
    var body: some View {
        return VStack(alignment: .leading, spacing: Constants.space) {
            Text(iconConnection)
                .frame(width: Constants.width, height: 20)
                .foregroundColor(changeBkColor(color : self.color))
                .font(fontAwesome)
            Text(connectionText)
                .frame(width: Constants.width, height: 16)
                .foregroundColor(changeBkColor(color : self.color))
                .font(textFont)
        }
        .frame(width: Constants.width, height: Constants.stackHeight)
        .onAppear {
            subcribeObservable()
        }
    }
    
    func changeBkColor(color: Int) -> Color
    {
        if(color == 0) {
            return Color.green;
        } else  {
            return Color.red
        }
    }
    
    func subcribeObservable() {
        ConnectionObserver.shared
            .connectionDidChanged
            .asObservable()
            .subscribe(onNext: { state in
                if state {
                    color = 0
                    connectionText = Status.online.rawValue
                } else {
                    color = 1
                    connectionText = Status.offline.rawValue
                }
            })
            .disposed(by: disposeBag)
    }
}
