//
//  RegionDetailsViewModelTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
@testable import BankLocator

class RegionDetailsViewModelTest: XCTestCase {
    private var viewModel: RegionDetailsViewModel?
    private var branch: Branch?
    private var region: Region?
    override func setUp() {
        super.setUp()
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
        let region = Region(name: "", branches: [branch])
        self.branch = branch
        self.region = region
        viewModel = RegionDetailsViewModel(region: region)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testDetailsViewModel() {
        XCTAssertEqual(viewModel?.regionSubject.value, self.region)
        XCTAssertEqual(viewModel?.regionSubject.value.branches[0], self.branch)
    }
}
