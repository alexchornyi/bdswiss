//
//  TimerObserver.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 19.11.2022.
//

import UIKit

protocol TimerObserverProtocol: AnyObject {
    func timerDidFire()
}

class TimerObserver {
    
    private var observers = NSHashTable<AnyObject>.weakObjects()
    private var timer: Timer?
    
    // MARK: - Shared manager
    static let sharedInstance = TimerObserver()
  
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
                self?.notifyTimerDidFire()
            }
        }
    }

    @objc private func applicationDidEnterForegraund() {
        timer?.invalidate()
    }

    // MARK: Observers
    func addObserver(_ observer: TimerObserverProtocol) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
    }

    func removeObserver(_ observer: TimerObserverProtocol) {
        guard observers.contains(observer) else {
            return
        }
        observers.remove(observer)
    }
    
    @objc func notifyTimerDidFire() {
        observers.allObjects.forEach { observer in
            DispatchQueue.main.async {
                (observer as? TimerObserverProtocol)?.timerDidFire()
            }
        }
    }
}
