//
//  PersistenceManagerTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
@testable import BankLocator

class PersistenceManagerTest: XCTestCase {
    
    func testPersistenceManager() {
        let branch = Branch(type: BranchType.atm,
                             name: "JÄRVE KESKUS",
                             address: "PÄRNU MNT 238, 11624 TALLINN",
                             availability: "Ainult broneeritud kohtumised E-R  10:00-18:00L 10:00-14:00",
                             region: "Nõmme linnaosa",
                             isNoCash: true,
                             latitude: 59.39370556,
                             longitude: 24.72033333,
                             info: "Sularaha tehingud pangaautomaatides. Esindus on suletud al 31.10.2020",
                             hasCoinStation: nil)
        let branchList: BranchList = [branch]
        PersistenceManager.shared.estoniaBranchList = branchList
        XCTAssertNotNil(PersistenceManager.shared.estoniaBranchList)
        
        PersistenceManager.shared.latviaBranchList = branchList
        XCTAssertNotNil(PersistenceManager.shared.latviaBranchList)
        
        PersistenceManager.shared.lithuaniaBranchList = branchList
        XCTAssertNotNil(PersistenceManager.shared.lithuaniaBranchList)
    }
}
