//
//  ApplicationStore.swift
//  HealthSync
//
//  Created by Daniel Metzing on 16.04.19.
//  Copyright © 2019 Daniel Metzing. All rights reserved.
//

import Foundation

final class ApplicationStore {
    
    static let shared = ApplicationStore()
    
    private static let authorizationGrantedSuccessfullyKey = "authorizationGrantedSuccessfully"
    
    var isHealthAccessAuthorized: Bool {
        get { return UserDefaults.standard.bool(forKey: ApplicationStore.authorizationGrantedSuccessfullyKey) }
        set { UserDefaults.standard.set(newValue, forKey: ApplicationStore.authorizationGrantedSuccessfullyKey) }
    }
}
