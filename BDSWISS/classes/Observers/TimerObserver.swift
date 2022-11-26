//
//  TimerObserver.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 19.11.2022.
//

import UIKit
import RxSwift
import RxRelay

class TimerObserver {
    
    private var timer: Timer?
    
    // MARK: - Shared manager
    static let shared = TimerObserver()
    
    // MARK: Public
    public var timerDidFire = PublishRelay<()>()
  
    init() {
        applicationDidBecomeActive()
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
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: timeInSec, repeats: true) { [weak self] _ in
                self?.timerDidFire.accept(())
            }
        }
    }

    @objc private func applicationDidEnterForegraund() {
        timer?.invalidate()
        timer = nil
    }
}
