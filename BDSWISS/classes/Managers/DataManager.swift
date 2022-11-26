//
//  DataManager.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation
import RxSwift
import RxRelay

class DataManager: ObservableObject {
    
    // MARK: - Shared manager
    static let shared = DataManager()
    private var items: Rates?
    private var oldItems: Rates?
    
    @Published var rates = [Rate]()
    @Published var oldRates = [Rate]()
    
    private let apiClient = APIClient()
    private let disposeBag = DisposeBag()
    
    public var dataDidFailWith = PublishRelay<(Error)>()
    public var dataDidFinishLoad = PublishRelay<([Rate])>()

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
            self.dataDidFinishLoad.accept(self.rates)
        }, onError: { error in
            DispatchQueue.main.async { [weak self] in
                self?.dataDidFailWith.accept(error)
           }
       })
        .disposed(by: disposeBag)
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
