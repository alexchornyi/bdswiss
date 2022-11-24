//
//  DataManager.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation
import RxSwift

protocol DataManagerProtocol: AnyObject {
    func dataDidFinishLoad()
    func dataDidFailWith(error: Error)
}

class DataManager: ObservableObject {
    
    // MARK: - Shared manager
    static let sharedInstance = DataManager()
    private var observers = NSHashTable<AnyObject>.weakObjects()
    private var items: Rates?
    private var oldItems: Rates?
    
    @Published var rates = [Rate]()
    @Published var oldRates = [Rate]()
    
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    func fetchData() {
        apiClient.send(apiRequest: RatesRequest()).subscribe(onNext: { rate in
            if let items = self.items {
                self.oldItems = items
                if let oldRates = items.rates {
                    self.oldRates = oldRates
                }
            }
            self.items = rate
            self.rates = self.items?.rates ?? []
            self.notifyDataDidFinishLoad()
        }, onError: { error in
            DispatchQueue.main.async { [weak self] in
               self?.notifyDataDidFailLoad(error: error)
           }
       })
        .disposed(by: disposeBag)
    }
    
    // MARK: Observers
    func addObserver(_ observer: DataManagerProtocol) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
    }
    
    func removeObserver(_ observer: DataManagerProtocol) {
        guard observers.contains(observer) else {
            return
        }
        observers.remove(observer)
    }
    
    func notifyDataDidFinishLoad() {
        observers.allObjects.forEach { observer in
            (observer as? DataManagerProtocol)?.dataDidFinishLoad()
        }
    }
    
    func notifyDataDidFailLoad(error: Error) {
        observers.allObjects.forEach { observer in
            (observer as? DataManagerProtocol)?.dataDidFailWith(error: error)
        }
    }
    
    func numberOfItems() -> Int {
        items?.rates?.count ?? .zero
    }
    
    func getItemFor(index: Int) -> Rate? {
        items?.rates?[index]
    }
    
    func getOldRateFor(code: String) -> Rate? {
        oldItems?.rates?.first(where: { $0.symbol == code})
    }
    
    func getRateFor(code: String) -> Rate? {
        oldItems?.rates?.first(where: { $0.symbol == code})
    }
    
    func getItems() -> [Rate] {
        items?.rates ?? []
    }
}
