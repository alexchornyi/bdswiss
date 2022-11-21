//
//  MainVC.swift
//  DBSWISS
//
//  Created by Oleksandr Chornyi on 17.11.2022.
//

import UIKit
import Charts
import NVActivityIndicatorView

class MainVC: UIViewController {

    private enum Constants {
        static let iconFrame = CGRect(x: .zero, y: .zero, width: 50, height: 20)
        static let labelFrame = CGRect(x: .zero, y: 24, width: 50, height: 20)
        static let stateFrame = CGRect(x: .zero, y: .zero, width: 50, height: 44)
        static let rowHeight = 70.0
        static let iconImage = UIImage(named: "logo")
        static let online = "online"
        static let offline = "offline"
        static let noItems = "No items, pull down to refresh data"
        static let textOffline = "Sorry you are offline. Try again late or use pull to refresh"
    }

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var chartsView: LineChartView!
    
    private let connectionLabel = UILabel(frame: Constants.iconFrame)
    private let connectionStateLabel = UILabel(frame: Constants.labelFrame)
    private let refreshControl = UIRefreshControl()
    private let activity = NVActivityIndicatorView(frame: Constants.stateFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addConnectionStateIcon()
        setNavTitle()
        setupChartsView()
        setConnectionStatus(status: ConnectionObserver.sharedInstance.getReachableState())
        setupTableView()
        setupActivityIndicator()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ConnectionObserver.sharedInstance.addObserver(self)
        DataManager.sharedInstance.addObserver(self)
        TimerObserver.sharedInstance.addObserver(self)
        ChartsDataManager.shared.addObserver(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ConnectionObserver.sharedInstance.removeObserver(self)
        DataManager.sharedInstance.removeObserver(self)
        TimerObserver.sharedInstance.removeObserver(self)
        ChartsDataManager.shared.removeObserver(self)
    }
        
    private func setConnectionStatus(status: Bool = false) {
        connectionLabel.textColor = status ? .green : .red
        connectionStateLabel.textColor = status ? .green : .red
        connectionStateLabel.text = status ? Constants.online : Constants.offline
    }
    
    private func setNavTitle() {
        let imageView = UIImageView(image: Constants.iconImage)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
    
    private func addConnectionStateIcon() {
        let view = UIView(frame: Constants.stateFrame)
        connectionStateLabel.textAlignment = .center
        connectionStateLabel.backgroundColor = UIColor.clear

        connectionStateLabel.font = labelFont
        connectionStateLabel.textAlignment = .center
        connectionStateLabel.backgroundColor = UIColor.clear

        connectionLabel.font = iconFont
        connectionLabel.text = iconConnection
        connectionLabel.textAlignment = .center
        connectionLabel.backgroundColor = UIColor.clear
        view.addSubview(connectionLabel)
        view.addSubview(connectionStateLabel)
        let barButton = UIBarButtonItem(customView: view)
        navigationItem.rightBarButtonItem = barButton
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UINib.init(nibName: MainTVC.className, bundle: nil), forCellReuseIdentifier: MainTVC.className)
        
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        tableView.refreshControl = refreshControl
   }
    
    @objc private func fetchData() {
        if !ConnectionObserver.sharedInstance.getReachableState() {
            NotificationsManager.shared.show(message: Constants.textOffline)
            refreshControl.endRefreshing()
            return
        }
        activity.startAnimating()
        DataManager.sharedInstance.fetchData()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activity)
        activity.center = view.center
        activity.color = .systemPink
        activity.type = .ballScaleMultiple
    }
}

// MARK: - ConnectionObserver -
extension MainVC: ConnectionObserverProtocol {
    
    func connectionDidChanged(state: Bool) {
        setConnectionStatus(status: state)
    }
    
    func needReloadData() {
        fetchData()
    }
}

// MARK: - DataManager -
extension MainVC: DataManagerProtocol {
    
    func dataDidFinishLoad() {
        activity.stopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func dataDidFailWith(error: Error) {
        activity.stopAnimating()
        refreshControl.endRefreshing()
        tableView.reloadData()
        NotificationsManager.shared.show(error: error)
    }
}

// MARK: - UITableView Delegate -
extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.rowHeight
    }
}

// MARK: - UITableView Data Source -
extension MainVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = DataManager.sharedInstance.numberOfItems()
        count == .zero ? tableView.setNoDataPlaceholder(Constants.noItems) : tableView.removeNoDataPlaceholder()
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : MainTVC? = tableView.dequeueReusableCell(withIdentifier: MainTVC.className) as? MainTVC
        if cell == nil {
            cell = MainTVC(style: UITableViewCell.CellStyle.default, reuseIdentifier: MainTVC.className)
        }
        if let rate = DataManager.sharedInstance.getItemFor(index: indexPath.row) {
            cell?.set(rate: rate)
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: MainTVC.className)
    }
}

// MARK: - UITableView Data Source -
extension MainVC: TimerObserverProtocol {
    func timerDidFire() {
        fetchData()
    }
}

// MARK: - Charts View -

extension MainVC {
    
    func setupChartsView() {
        chartsView.backgroundColor = .clear
        chartsView.delegate = self
        chartsView.rightAxis.enabled = false
        chartsView.chartDescription.enabled = false
        chartsView.xAxis.enabled = false
        setDataForCharts()
    }
    
    func setDataForCharts() {
        chartsView.data = ChartsDataManager.shared.getChartsData()
    }
}

// MARK: - ChartsDataManagerProtocol -
extension MainVC: ChartsDataManagerProtocol {

    func dataDidUpdated(chartData: LineChartData) {
        chartsView.clear()
        chartsView.data = chartData
    }
}

// MARK: - ChartsViewDelegate -
extension MainVC: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        NotificationsManager.shared.show(message: "\(entry.y.rounded(toPlaces: 4))")
        print(entry)
    }
}
