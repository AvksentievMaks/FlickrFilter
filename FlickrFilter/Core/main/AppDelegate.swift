//
//  AppDelegate.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © TEXEN. All rights reserved.
//

import UIKit
import FlickrKit

class AppDelegate: UIResponder {

    var window: UIWindow?
   
    lazy private var router = RootRouter()
    lazy private var deeplinkHandler = DeeplinkHandler()
    lazy private var notificationsHandler = NotificationsHandler()
}

//MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FlickrKit.shared().initialize(withAPIKey: "3645a51773c163cb506d6cab379d9d56", sharedSecret: "1abc53e733b3ba0c")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        self.notificationsHandler.configure()
        self.router.loadMainAppStructure()
        
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        // To enable full universal link functionality add and configure the associated domain capability
        // https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            
            self.deeplinkHandler.handleDeeplink(with: url)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // To enable full remote notifications functionality you should first register the device with your api service
        //https://developer.apple.com/library/content/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/
        self.notificationsHandler.handleRemoteNotification(with: userInfo)
    }
}
