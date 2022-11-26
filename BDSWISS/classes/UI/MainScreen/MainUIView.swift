//
//  MainUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 23.11.2022.
//

import SwiftUI
import Charts
import RxSwift

struct MainUIView: View {
    
    private enum Constants {
        static let space = 16.0
        static let maxHeight = 200.0
    }
    
    let chartsView = LineChartView()
    
    @ObservedObject var dataManager = DataManager.shared
    private let disposeBag = DisposeBag()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack(alignment: .leading, spacing: Constants.space) {
                    List(dataManager.rates) { rate in
                        MainCell(rate: rate)
                    }
                    .background(Color.red)
                    ChartsView()
                        .frame(maxWidth: .infinity ,maxHeight: Constants.maxHeight, alignment: .bottomTrailing)
                        .background(Color.clear)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Image("logo").resizable()
                            .scaledToFit()
                            .frame(width: 204, height: 55, alignment: .trailing)
                    }
                } .toolbar {
                    ConnectionView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            subscribeObservable()
            DataManager.shared.fetchData()
        }
    }
    
    func subscribeObservable() {
        DataManager.shared
            .dataDidFailWith
            .asObservable()
            .subscribe(onNext: { (error) in
                NotificationsManager.shared.show(error: error)
            })
            .disposed(by: disposeBag)
        
        TimerObserver.shared
            .timerDidFire
            .asObservable()
            .subscribe(onNext: { _ in
                DataManager.shared.fetchData()
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
struct MainUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainUIView()
    }
}
#endif
