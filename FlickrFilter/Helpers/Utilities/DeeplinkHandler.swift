//
//  DeeplinkHandler.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev.
//  Copyright © TEXEN. All rights reserved.
//

import Foundation

class DeeplinkHandler {

    enum DeeplinkPath: String {
        
        case resetPassword = "/api/password/reset" // example deeplink path
    }

    //MARK: Main
    func handleDeeplink(with url: URL) {
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true), let path = self.getPath(from: components) else {
            
            return
        }

        switch path {
        case .resetPassword:
            
            self.handleResetPasword(with: components)
        }
    }
}

//MARK: - Private
extension DeeplinkHandler {
    
    private func getPath(from components: URLComponents) -> DeeplinkPath? {
        
        return DeeplinkPath(rawValue: components.path)
    }
    
    private func handleResetPasword(with components: URLComponents) {
        
        //implementation goes here, probably extract token from query items and send to api
    }
}
