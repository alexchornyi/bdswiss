//
//  MainUIView.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 23.11.2022.
//

import SwiftUI
import Charts

struct MainUIView: View {
    
    let chartsView = LineChartView()
    
    @State var configuration: Configuration?
    
    @ObservedObject var dataManager = DataManager.sharedInstance
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 16) {
                    List(dataManager.rates) { rate in
                        MainCell(rate: rate)
                    }
                    .background(Color.red)
                    ChartsView()
                        .frame(maxWidth: .infinity ,maxHeight: 200, alignment: .bottomTrailing)
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
            configuration = Configuration(mainView: self)
            DataManager.sharedInstance.fetchData()
        }
        .onDisappear {
            configuration?.remove()
        }
    }
}

extension MainUIView {
    // MARK: - TimerObserverProtocol -
    
    final class Configuration:  NSObject, TimerObserverProtocol, DataManagerProtocol {
        
        var mainView: MainUIView?
        
        init(mainView: MainUIView?) {
            self.mainView = mainView
            
            super.init()
            add()
        }
        
        func add() {
            TimerObserver.sharedInstance.addObserver(self)
            DataManager.sharedInstance.addObserver(self)
        }
        
        func remove() {
            TimerObserver.sharedInstance.addObserver(self)
            DataManager.sharedInstance.addObserver(self)
        }
        
        func timerDidFire() {
            DataManager.sharedInstance.fetchData()
        }
        
        func dataDidFinishLoad() { }
        
        func dataDidFailWith(error: Error) {
            NotificationsManager.shared.show(error: error)
        }
    }
}

struct MainCell: View {

    let rate: Rate
    @State var color = 2;
    @State var iconText: String = iconUpDown

    
    var body: some View {
        HStack {
            Image(uiImage: rate.firstFlag)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 40, maxWidth: 40, minHeight: 40, maxHeight: 40)
            Spacer()
                .frame(width: 16)
            Text(iconNext)
                .font(fontAwesome)
                .frame(width: 20.0, alignment: .center)
            Spacer()
                .frame(width: 16)
            Image(uiImage: rate.secondFlag)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 40, maxWidth: 40, minHeight: 40, maxHeight: 40)
            Spacer()
                .frame(width: 16)
            Text(rate.priceName)
                .foregroundColor(changeColor(color: color))
                .font(textFont)
                .frame(minWidth: 100, maxWidth: .infinity, alignment: .trailing)
            Text(iconText)
                .foregroundColor(changeColor(color: color))
                .font(fontAwesome)
                .frame(width: 20.0, alignment: .trailing)
        }
        .onAppear {
            checkRate()
        }
    }
    
    func checkRate() {
        guard let symbol = rate.symbol, let oldValue = DataManager.sharedInstance.getOldRateFor(code: symbol) else {
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


#if DEBUG
struct MainUIView_Previews: PreviewProvider {
    static var previews: some View {
        MainUIView()
    }
}
#endif

struct ConnectionView: View {
    
    enum Status: String {
        case online = "online"
        case offline = "ofline"
    }
    
    @State var color = 0;
    @State var connectionText: String = Status.online.rawValue
    
    @State var configuration: Configuration?
    
    var body: some View {
        return VStack(alignment: .leading, spacing: 4) {
            Text(iconConnection)
                .frame(width: 50, height: 20)
                .foregroundColor(changeBkColor(color : self.color))
                .font(Font.custom("FontAwesome6Free-Solid", size: 20))
            Text(connectionText)
                .frame(width: 50, height: 16)
                .foregroundColor(changeBkColor(color : self.color))
                .font(Font.system(size: 14))
        }
        .frame(width: 50, height: 40)
        .onAppear {
            configuration = Configuration(connectionView: self)
        }
        .onDisappear {
            configuration?.remove()
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
    
}

extension ConnectionView {
    // MARK: - ConnectionObserver -
    
    final class Configuration:  NSObject, ConnectionObserverProtocol {
        
        var connectionView: ConnectionView?
        
        init(connectionView: ConnectionView? = nil) {
            self.connectionView = connectionView
            
            super.init()
            add()
        }
        
        func add() {
            ConnectionObserver.sharedInstance.addObserver(self)
        }
        
        func remove() {
            ConnectionObserver.sharedInstance.removeObserver(self)
        }
        
        func connectionDidChanged(state: Bool) {
            if state {
                connectionView?.color = 0
                connectionView?.connectionText = Status.online.rawValue
            } else {
                connectionView?.color = 1
                connectionView?.connectionText = Status.offline.rawValue
            }
        }
        
        func needReloadData() {
            DataManager.sharedInstance.fetchData()
        }
        
    }
}


struct ChartsView: UIViewRepresentable {
    
    @State var lineChartsView: LineChartView = LineChartView()
    
    func makeCoordinator() -> ChartsViewCoordinator {
        ChartsViewCoordinator(chartsView: self)
    }
    
    func makeUIView(context: Context) -> LineChartView {
        lineChartsView.backgroundColor = .clear
        lineChartsView.delegate = context.coordinator
        lineChartsView.rightAxis.enabled = false
        lineChartsView.chartDescription.enabled = false
        lineChartsView.xAxis.enabled = false
        lineChartsView.data = ChartsDataManager.shared.getChartsData()
        ChartsDataManager.shared.addObserver(context.coordinator)
        return lineChartsView
    }
    
    func updateUIView(_ activityIndicator: LineChartView, context: Context) {
    }
    
    
    // MARK: - ChartsViewDelegate -
    public class ChartsViewCoordinator: NSObject, ChartViewDelegate, ChartsDataManagerProtocol {
        
        var chartsView: ChartsView?
        
        init(chartsView: ChartsView? = nil) {
            self.chartsView = chartsView
        }
        
        func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
            NotificationsManager.shared.show(message: "\(entry.y.rounded(toPlaces: 4))")
            print(entry)
        }
        
        func dataDidUpdated(chartData: LineChartData) {
            chartsView?.lineChartsView.clear()
            chartsView?.lineChartsView.data = chartData
        }
    }
}
