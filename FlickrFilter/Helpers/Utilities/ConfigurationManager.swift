//
//  ConfigurationManager.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © TEXEN. All rights reserved.
//

import Foundation

/**
 Use the Configuration.plist file to provide variables dependent on build configuration.
 An example would be the backend url, where for different build configurations you have different backend urls.
 */
class ConfigurationManager {

    enum Configuration: String {
        case debug = "Debug"
        case release = "Release"
        case production = "Production"
    }

    static var shared: ConfigurationManager {
     
        return self.instance
    }
    
    private static let instance = ConfigurationManager()
    
    private let configurationKey = "Configuration"
    private let configurationDictionaryName = "Configuration"
    private let backendUrlKey = "backendUrl"

    let activeConfiguration: Configuration
    private let activeConfigurationDictionary: NSDictionary

    //MARK: Init
    init () {
        
        let bundle = Bundle(for: ConfigurationManager.self)
        
        guard let rawConfiguration = bundle.object(forInfoDictionaryKey: self.configurationKey) as? String, let activeConfiguration = Configuration(rawValue: rawConfiguration), let configurationDictionaryPath = bundle.path(forResource: self.configurationDictionaryName, ofType: "plist"), let configurationDictionary = NSDictionary(contentsOfFile: configurationDictionaryPath), let activeEnvironmentDictionary = configurationDictionary[activeConfiguration.rawValue] as? NSDictionary else {
        
            fatalError("Configuration Error")
        }
        
        self.activeConfiguration = activeConfiguration
        self.activeConfigurationDictionary = activeEnvironmentDictionary
    }
}

//MARK: - Main
extension ConfigurationManager {
    
    func isRunning(in configuration: Configuration) -> Bool {
        
        return self.activeConfiguration == configuration
    }
    
    func getBackendUrl() -> URL {
        
        let backendUrlString: String = self.getActiveVariableValue(forKey: self.backendUrlKey)
        
        guard let backendUrl = URL(string: backendUrlString) else {
            
            fatalError("Backend URL missing")
        }
        
        return backendUrl
    }
    
    private func getActiveVariableValue<V>(forKey key: String) -> V {
        
        guard let value = self.activeConfigurationDictionary[key] as?  V else {
            
            fatalError("No value satysfying requirements")
        }
        
        return value
    }
}

