//
//  BranchTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
@testable import BankLocator

class BranchTest: XCTestCase {
    private var branch: Branch?
    override func setUp() {
        super.setUp()
        self.branch = Branch(type: BranchType.atm,
                             name: "JÄRVE KESKUS",
                             address: "PÄRNU MNT 238, 11624 TALLINN",
                             availability: "Ainult broneeritud kohtumised E-R  10:00-18:00L 10:00-14:00",
                             region: "Nõmme linnaosa",
                             isNoCash: true,
                             latitude: 59.39370556,
                             longitude: 24.72033333,
                             info: "Sularaha tehingud pangaautomaatides. Esindus on suletud al 31.10.2020",
                             hasCoinStation: nil)
    }
    
    override func tearDown() {
        branch = nil
        super.tearDown()
    }
    
    func testAtm() {
        XCTAssertEqual(self.branch?.type.alias, "A")
        XCTAssertEqual(self.branch?.type.name, "ATM")
    }
}
