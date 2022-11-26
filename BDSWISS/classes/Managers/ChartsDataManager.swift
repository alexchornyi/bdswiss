//
//  ChartsDataManager.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import UIKit
import Charts
import RxSwift
import RxRelay

class ChartsDataManager {
    
    // MARK: - Private -
    private var chartsElements: [ChartDataElement] = [ChartDataElement]()
    private let disposeBag = DisposeBag()
    
    // MARK: - Public -
    public var dataDidUpdated = PublishRelay<(LineChartData)>()
    
    // MARK: - Shared manager
    static let shared = ChartsDataManager()
    
    init() {
        subscribeObservable()
    }
    
    func notifyDataDidChanged() {
        DispatchQueue.main.async { [weak self] in
            var chartDataSets: [ChartDataSetProtocol] = [ChartDataSetProtocol]()
            self?.chartsElements.forEach { chartDataElement in
                chartDataSets.append(chartDataElement.chartSet!)
            }
            let data = LineChartData(dataSets: chartDataSets)
            data.setDrawValues(false)
            self?.dataDidUpdated.accept((data))
        }
    }
    
    func getChartsData() -> LineChartData {
        var chartDataSets: [ChartDataSetProtocol] = [ChartDataSetProtocol]()
        chartsElements.forEach { chartDataElement in
            chartDataSets.append(chartDataElement.chartSet!)
        }
        let data = LineChartData(dataSets: chartDataSets)
        data.setDrawValues(false)
        return data
    }
    
    func subscribeObservable() {
        DataManager.shared
            .dataDidFinishLoad
            .asObservable()
            .subscribe(onNext: { [unowned self] (rates) in
                rates.forEach({ rate in
                    if let chartElement = chartsElements.first(where: {$0.code == rate.symbol}) {
                        chartElement.addValue(rate: rate)
                    } else {
                        let newElement = ChartDataElement()
                        newElement.addValue(rate: rate)
                        chartsElements.append(newElement)
                    }
                })
                notifyDataDidChanged()
            })
            .disposed(by: disposeBag)
    }
}

class ChartDataElement {
    var code: String?
    var values: [ChartDataEntry] = [ChartDataEntry]()
    var chartSet: LineChartDataSet?
    
    var colors: [UIColor] =
    [
        UIColor.red,
        UIColor.systemBlue,
        UIColor.systemPink,
        UIColor.systemCyan,
        UIColor.systemMint,
        UIColor.systemOrange,
        UIColor.systemPurple,
        UIColor.systemYellow,
        UIColor.systemTeal,
        UIColor.black,
        UIColor.darkGray
    ]
    
    var color: UIColor?
    
    init() {
        color = colors.randomElement() ?? .systemBlue
    }
    
    func addValue(rate: Rate) {
        code = rate.symbol
        if values.count == 10 {
            values.remove(at: 0)
        }
        values.append(ChartDataEntry(x: Double(rate.date.timeIntervalSince1970), y: rate.price))
        chartSet = LineChartDataSet(entries: values, label: code ?? "set")
        chartSet?.drawCirclesEnabled = false
        chartSet?.lineWidth = 2.0
        chartSet?.mode = .cubicBezier
        chartSet?.setColor(color ?? .systemBlue)
    }
}
