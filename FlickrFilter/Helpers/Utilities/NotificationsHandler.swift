//
//  NotificationsHandler.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © TEXEN. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsHandler: NSObject {

    // MARK: Main
    func configure() {
        
        UNUserNotificationCenter.current().delegate = self
    }

    func registerForRemoteNotifications() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {_, _ in
            
            // do nothing for now
        }

        UIApplication.shared.registerForRemoteNotifications()
    }

    func handleRemoteNotification(with userInfo: [AnyHashable: Any]) {
        
    }
}

//MARK: - UNUserNotificationCenterDelegate
extension NotificationsHandler: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler(.alert)
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    
    // The method will be called on the delegate when the application is launched in response to the user's request to view in-app notification settings. Add UNAuthorizationOptionProvidesAppNotificationSettings as an option in requestAuthorizationWithOptions:completionHandler: to add a button to inline notification settings view and the notification settings view in Settings. The notification will be nil when opened from Settings.
    @available(iOS 12.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        
    }
}
