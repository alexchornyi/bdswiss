//
//  ChartsUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 25.11.2022.
//

import SwiftUI
import Charts
import RxSwift

struct ChartsView: UIViewRepresentable {
    
    @State var lineChartsView: LineChartView = LineChartView()
    private let disposeBag = DisposeBag()
    
    func makeCoordinator() -> ChartsViewCoordinator {
        subscribeObservable()
        return ChartsViewCoordinator()
    }
    
    func makeUIView(context: Context) -> LineChartView {
        lineChartsView.backgroundColor = .clear
        lineChartsView.delegate = context.coordinator
        lineChartsView.rightAxis.enabled = false
        lineChartsView.chartDescription.enabled = false
        lineChartsView.xAxis.enabled = false
        lineChartsView.data = ChartsDataManager.shared.getChartsData()
        return lineChartsView
    }
    
    func updateUIView(_ activityIndicator: LineChartView, context: Context) {
    }
    
    func subscribeObservable() {
        ChartsDataManager.shared
            .dataDidUpdated
            .asObservable()
            .subscribe(onNext: { (chartData) in
                lineChartsView.clear()
                lineChartsView.data = chartData
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - ChartsViewDelegate -
    public class ChartsViewCoordinator: NSObject, ChartViewDelegate {
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            NotificationsManager.shared.show(message: "\(entry.y.rounded(toPlaces: 4))")
            print(entry)
        }

    }
}
