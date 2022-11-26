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
import RxRelay

class ConnectionObserver {
    
    // MARK: - Shared manager
    static let shared = ConnectionObserver()
    
    // MARK: - Private -
    private let reachability = try? Reachability()
    private var isReachable = false
    private let disposeBag = DisposeBag()

    // MARK: - Public -
    public var connectionDidChanged = PublishRelay<(Bool)>()

    init() {
        applicationDidBecomeActive()
        
        reachability?.rx.reachabilityChanged
            .subscribe(onNext: { [weak self] _ in
                
                switch self?.reachability?.connection {
                case .wifi:
                    if !(self?.isReachable ?? true) {
                        self?.isReachable = true
                        self?.connectionDidChanged.accept((self?.isReachable ?? false))
                    }
                case .cellular:
                    if !(self?.isReachable ?? true) {
                        self?.isReachable = true
                        self?.connectionDidChanged.accept((self?.isReachable ?? false))
                    }
                case .unavailable, .none:
                    if self?.isReachable ?? false {
                        self?.isReachable = false
                        self?.connectionDidChanged.accept((self?.isReachable ?? false))
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

    func getReachableState() -> Bool {
        return isReachable
    }
}
