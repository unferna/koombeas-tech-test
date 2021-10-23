//
//  KoombeasFightersTests.swift
//  KoombeasFightersTests
//
//  Created by Fernando Florez on 22/10/21.
//

import XCTest
@testable import KoombeasFighters

class KoombeasFightersTests: XCTestCase {
    // System under test
    private var dataService = HomeDataService.shared
    private var networkMonitor = NetworkMonitor.shared
    
    private let internetMessageError = "This test must be runned with internet connection"
    
    func testUniverseFilter() throws {
        try XCTSkipUnless(networkMonitor.isReachable, internetMessageError)
        
        let universeExpected = "Mario"
        dataService.getFighters(filteredBy: .universe, withValue: universeExpected, completion: { fighters in
            if let firstFighter = fighters.first {
                XCTAssertEqual(firstFighter.universe, universeExpected)
            
            } else {
                XCTFail("No fighter detected. Check response API")
            }
            
            let fighterFromAnotherUniverse = fighters.first(where: { $0.universe != universeExpected })
            XCTAssertNil(fighterFromAnotherUniverse)
            
        }, failure: { error in
            XCTFail(error.localizedDescription)
        })
    }
    
    func testRateFilter() throws {
        try XCTSkipUnless(networkMonitor.isReachable, internetMessageError)
        
        let rateExpected = "3"
        dataService.getFighters(filteredBy: .rate, withValue: rateExpected, completion: { fighters in
            let rateInt = Int(rateExpected)!
            
            if let firstFighter = fighters.first {
                XCTAssertEqual(firstFighter.rate, rateInt)
            
            } else {
                XCTFail("No fighter detected. Check response API")
            }
            
            let numberOfFightersWithOtherRate = fighters.filter { $0.rate != rateInt }.count
            XCTAssertEqual(numberOfFightersWithOtherRate, 0)
            
        }, failure: { error in
            XCTFail(error.localizedDescription)
        })
    }
}
