//
//  HomeDataService.swift
//  KoombeasFighters
//
//  Created by Fernando Florez on 22/10/21.
//

import Foundation

enum FighterFilter: String {
    case all = "all"
    case universe = "universe"
    case rate = "rate"
}

class HomeDataService {
    private let network = NetworkManager()
    private let networkMonitor = NetworkMonitor.shared
    private let queue: DispatchQueue!
    
    static let shared = HomeDataService()
    
    private init() {
        queue = DispatchQueue(label: "HomeDataServiceQueue")
    }
    
    func getUniverses(completion: @escaping ([Universe]) -> Void, failure: @escaping (GeneralError) -> Void) {
        // Load Universes
        let universesAPI = "https://593cdf8fb56f410011e7e7a9.mockapi.io/universes"
        
        if networkMonitor.isReachable {
            network.request(url: universesAPI, completion: { data in
                do {
                    let universes = try JSONDecoder().decode([Universe].self, from: data)
                    LocalStorage.shared.saveUniverses(data)
                    
                    completion(universes)
                    
                } catch {
                    failure(GeneralError.message(string: "Couldn't convert invalid response"))
                }
                
            }, failure: { error in
                failure(error)
            })
        
        } else {
            do {
                if let universesData = LocalStorage.shared.getUniverses() {
                    let universes = try JSONDecoder().decode([Universe].self, from: universesData)
                    completion(universes)
                    
                } else {
                    failure(GeneralError.message(string: "There aren't universes saved"))
                }
                
            } catch {
                failure(GeneralError.message(string: "There aren't universes saved"))
            }
        }
    }
    
    func getFighters(filteredBy: FighterFilter = .all, withValue: String = "", completion: @escaping ([Fighter]) -> Void, failure: @escaping (GeneralError) -> Void) {
        var fightersAPI = "https://593cdf8fb56f410011e7e7a9.mockapi.io/fighters"
        
        if filteredBy != .all && !withValue.isEmpty {
            if filteredBy == .rate {
                if let intValue = Int(withValue) {
                    fightersAPI += "?rate=\( intValue )"
                }
            
            } else {
                LocalStorage.shared.saveUniverseSelection(withValue)
                
                let encodedParam = withValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                fightersAPI += "?universe=\( encodedParam ?? "" )"
            }
        }
        
        if networkMonitor.isReachable {
            if filteredBy == .all {
                LocalStorage.shared.saveUniverseSelection("")
            }
            
            network.request(url: fightersAPI, completion: { data in
                do {
                    let fighters = try JSONDecoder().decode([Fighter].self, from: data)
                    LocalStorage.shared.saveFighters(data)
                    
                    completion(fighters)
                    
                } catch {
                    failure(GeneralError.message(string: "Couldn't convert invalid response"))
                }
                
            }, failure: { error in
                failure(error)
            })
        
        } else {
            do {
                if let universesData = LocalStorage.shared.getFighters() {
                    let fighters = try JSONDecoder().decode([Fighter].self, from: universesData)
                    completion(fighters)
                    
                } else {
                    failure(GeneralError.message(string: "There aren't fighters saved"))
                }
                
            } catch {
                failure(GeneralError.message(string: "There aren't fighters saved"))
            }
        }
    }
    
    func loadHome(completion: @escaping ([Universe], [Fighter]) -> Void, failure: @escaping (GeneralError) -> Void) {
        var universes: [Universe] = []
        var fighters: [Fighter] = []
        
        let group = DispatchGroup()
        
        queue.async { [weak self] in
            group.enter()
            
            self?.getUniverses(completion: { universesLoaded in
                universes = universesLoaded
                
                // Replaced according the design
                if universes[0].name == "Super Smash Bros" {
                    universes[0].name = "All"
                }
                
                self?.getFighters(completion: { fightersLoaded in
                    fighters = fightersLoaded
                    group.leave()
                    
                }, failure: { error in
                    failure(error)
                })
                
            }, failure: { error in
                failure(error)
            })
            
            group.wait()
        }
        
        group.notify(queue: queue) {
            completion(universes, fighters)    
        }
    }
}
