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
    
    public var universeSelection: String {
        guard let universeName = UserDefaults.standard.value(forKey: DataKeys.universeSelected) as? String else { return "none" }
        return universeName
    }
    
    public func markOnboardingAsSeen() {
        UserDefaults.standard.set(true, forKey: DataKeys.onboardingSeen)
    }
    
    public func saveUniverses(_ universes: Data) {
        UserDefaults.standard.set(universes, forKey: DataKeys.cachedUniverses)
    }
    
    public func saveUniverseSelection(_ universeName: String) {
        UserDefaults.standard.set(universeName, forKey: DataKeys.universeSelected)
    }
    
    public func saveFighters(_ fighters: Data) {
        UserDefaults.standard.set(fighters, forKey: DataKeys.cachedFighters)
    }
    
    public func getUniverses() -> Data? {
        guard let universesData = UserDefaults.standard.value(forKey: DataKeys.cachedUniverses) as? Data else { return nil }
        return universesData
    }
    
    public func getFighters() -> Data? {
        guard let fightersData = UserDefaults.standard.value(forKey: DataKeys.cachedFighters) as? Data else { return nil }
        return fightersData
    }
}
