//
//  ChartsDataManager.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import UIKit
import Charts

protocol ChartsDataManagerProtocol: AnyObject {
    func dataDidUpdated(chartData: LineChartData)
}

class ChartsDataManager {
    
    private var observers = NSHashTable<AnyObject>.weakObjects()
    private var chartsElements: [ChartDataElement] = [ChartDataElement]()
    
    // MARK: - Shared manager
    static let shared = ChartsDataManager()
  
    init() {
        DataManager.sharedInstance.addObserver(self)
    }
    
    // MARK: Observers
    func addObserver(_ observer: ChartsDataManagerProtocol) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
    }

    func removeObserver(_ observer: ChartsDataManagerProtocol) {
        guard observers.contains(observer) else {
            return
        }
        observers.remove(observer)
    }
    
    @objc func notifyTimerDidFire() {
        observers.allObjects.forEach { observer in
            DispatchQueue.main.async { [weak self] in
                var chartDataSets: [ChartDataSetProtocol] = [ChartDataSetProtocol]()
                self?.chartsElements.forEach { chartDataElement in
                    chartDataSets.append(chartDataElement.chartSet!)
                }
                let data = LineChartData(dataSets: chartDataSets)
                data.setDrawValues(false)
                (observer as? ChartsDataManagerProtocol)?.dataDidUpdated(chartData: data)
            }
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
}

// MARK: - Data Manager Protocol -
extension ChartsDataManager: DataManagerProtocol {
    
    func dataDidFinishLoad() {
        DataManager.sharedInstance.getItems().forEach({ rate in
            if let chartElement = chartsElements.first(where: {$0.code == rate.symbol}) {
                chartElement.addValue(rate: rate)
            } else {
                let newElement = ChartDataElement()
                newElement.addValue(rate: rate)
                chartsElements.append(newElement)
            }
        })
        notifyTimerDidFire()
    }
    
    func dataDidFailWith(error: Error) { }
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
