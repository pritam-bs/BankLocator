//
//  DetailsViewModelTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
@testable import BankLocator

//"t":0,
//"n":"JÄRVE KESKUS",
//"a":"PÄRNU MNT 238, 11624 TALLINN",
//"av":"Ainult broneeritud kohtumised E-R  10:00-18:00L 10:00-14:00\n",
//"r":"Nõmme linnaosa",
//"ncash":true,
//"lat":59.39370556,
//"lon":24.72033333,
//"i":"Sularaha tehingud pangaautomaatides. Esindus on suletud al 31.10.2020"

class DetailsViewModelTest: XCTestCase {
    private var branch: Branch?
    private var viewModel: DetailsViewModel?
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
        viewModel = DetailsViewModel(branch: self.branch!)
    }
    
    override func tearDown() {
        branch = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testDetailsViewModel() {
        XCTAssertEqual(viewModel?.branchSubject.value, self.branch)
    }
}
