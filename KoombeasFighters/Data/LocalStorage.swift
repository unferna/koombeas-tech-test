//
//  LocalStorage.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import Foundation

class LocalStorage {
    static let shared = LocalStorage()
    
    private init() {}
    
    public lazy var isOnboardingSeen: Bool = {
        guard let seen = UserDefaults.standard.value(forKey: DataKeys.onboardingSeen) as? Bool else { return false }
        return seen
    } ()
    
    public func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: DataKeys.onboardingSeen)
    }
}
