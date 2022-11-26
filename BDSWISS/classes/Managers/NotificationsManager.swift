//
//  NotificationsManager.swift
//  BDSWISS
//
//  Created by Oleksandr Chornyi on 21.11.2022.
//

import UIKit
import SwiftEntryKit

class NotificationsManager {
    
    private enum Constants {
        static let systemFont16 = UIFont.boldSystemFont(ofSize: 16)
        static let systemFont12 = UIFont.systemFont(ofSize: 12)
        static let errorText = "Error!"
        static let infoText = "Info"
        static let duration = 3.0
    }
    
    // MARK: - Shared manager
    static let shared = NotificationsManager()
    
    func show(message: String) {
        DispatchQueue.main.async {
            // Generate top floating entry and set some properties
            var attributes = EKAttributes.toast
            attributes.entryBackground = .visualEffect(style: .dark)
            attributes.precedence = .enqueue(priority: .normal)
            attributes.displayDuration = Constants.duration
            attributes.entryInteraction = .dismiss
            attributes.screenInteraction = .dismiss
            
            let title = EKProperty.LabelContent(text: Constants.infoText, style: .init(font: Constants.systemFont16, color: .white))
            let description = EKProperty.LabelContent(text: message, style: .init(font: Constants.systemFont12, color: .white))
            let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
            let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
            
            let contentView = EKNotificationMessageView(with: notificationMessage)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    func show(error: Error) {
        // Generate top floating entry and set some properties
        var attributes = EKAttributes.bottomToast
        attributes.entryBackground = .visualEffect(style: .dark)
        attributes.screenBackground = .color(color: EKColor.standardBackground)
        attributes.precedence = .enqueue(priority: .normal)
        attributes.displayDuration = Constants.duration
        attributes.entryInteraction = .dismiss
        attributes.screenInteraction = .dismiss
        
        let title = EKProperty.LabelContent(text: Constants.errorText, style: .init(font: Constants.systemFont16, color: EKColor(red: 1, green: 0, blue: 0)))
        let description = EKProperty.LabelContent(text: error.localizedDescription, style: .init(font: Constants.systemFont12, color: .white))
        let simpleMessage = EKSimpleMessage(image: nil, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
}
