//
//  ConnectionObserver.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 19.11.2022.
//

import UIKit
import Reachability
import RxReachability
import RxSwift

protocol ConnectionObserverProtocol: AnyObject {
    func connectionDidChanged(state: Bool)
    func needReloadData()
}

class ConnectionObserver {
    
    private var observers = NSHashTable<AnyObject>.weakObjects()
    //private var timer
    
    let disposeBag = DisposeBag()
    
    // MARK: - Shared manager
    static let sharedInstance = ConnectionObserver()
    private let reachability = try? Reachability()
    private var isReachable = false
    
    init() {
        applicationDidBecomeActive()
        
        reachability?.rx.reachabilityChanged
            .subscribe(onNext: { [weak self] _ in
                
                switch self?.reachability?.connection {
                case .wifi:
                    if !(self?.isReachable ?? true) {
                        self?.isReachable = true
                        self?.notifyConnectionDidChange()
                    }
                case .cellular:
                    if !(self?.isReachable ?? true) {
                        self?.isReachable = true
                        self?.notifyConnectionDidChange()
                    }
                case .unavailable, .none:
                    if self?.isReachable ?? false {
                        self?.isReachable = false
                        self?.notifyConnectionDidChange()
                    }
                }
            })
              .disposed(by: disposeBag)
        
        switch reachability?.connection {
        case .wifi:
            isReachable = true
        case .cellular:
            isReachable = true
        case .unavailable:
            isReachable = false
        case .none:
            isReachable = false
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterForegraund),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc private func applicationDidBecomeActive() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    @objc private func applicationDidEnterForegraund() {
        reachability?.stopNotifier()
    }

    // MARK: Observers
    func addObserver(_ observer: ConnectionObserverProtocol) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
    }
    
    func removeObserver(_ observer: ConnectionObserverProtocol) {
        guard observers.contains(observer) else {
            return
        }
        observers.remove(observer)
    }
    
    func notifyConnectionDidChange() {
        observers.allObjects.forEach { observer in
            DispatchQueue.main.async { [weak self] in
                (observer as? ConnectionObserverProtocol)?.connectionDidChanged(state: self?.isReachable ?? false)
            }
        }
    }

    func notifyNeedUpdate() {
        observers.allObjects.forEach { observer in
            DispatchQueue.main.async { [weak self] in
                (observer as? ConnectionObserverProtocol)?.needReloadData()
            }
        }
    }

    func getReachableState() -> Bool {
        return isReachable
    }
}
