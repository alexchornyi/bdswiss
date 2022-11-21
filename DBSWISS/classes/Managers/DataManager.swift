//
//  DataManager.swift
//  DBSWISS
//
//  Created by Oleksandr Chornyi on 20.11.2022.
//

import Foundation

protocol DataManagerProtocol: AnyObject {
    func dataDidFinishLoad()
    func dataDidFailWith(error: Error)
}

class DataManager {
    
    // MARK: - Shared manager
    static let sharedInstance = DataManager()
    private var observers = NSHashTable<AnyObject>.weakObjects()
    private var items: Rates?
    private var oldItems: Rates?
    
    func fetchData() {
        
        guard let url = URL(string: serverURL) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, err in
            guard let data = data, err == nil else {
                if let error = err {
                    DispatchQueue.main.async { [weak self] in
                        self?.notifyDataDidFailLoad(error: error)
                    }
                }
                return
            }
            
            do {
                if let items = self?.items {
                    self?.oldItems = items
                }
                self?.items = try JSONDecoder().decode(Rates.self, from: data)
                
                DispatchQueue.main.async { [weak self] in
                    self?.notifyDataDidFinishLoad()
                }
                
            } catch let jsonErr {
                print("failed to decode json:", jsonErr)
                DispatchQueue.main.async { [weak self] in
                    self?.notifyDataDidFailLoad(error: jsonErr)
                }
            }
        }.resume()
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
    
    func getItems() -> [Rate]? {
        items?.rates
    }
}
