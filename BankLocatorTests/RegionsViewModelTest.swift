//
//  RegionsViewModelTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
import Combine
@testable import BankLocator

class RegionsViewModelTest: XCTestCase {
    private var viewModel: RegionsViewModel?
    
    override func setUp() {
        super.setUp()
        viewModel = RegionsViewModel(network: Network.shared)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testRegionsViewModel() {
        var countries: [Country] = []
        let promise = expectation(description: "Regions View Model Test Successful")
        
        
        let cancelable = self.viewModel?.countries
            .sink { (completion) in
                
            } receiveValue: { (response) in
                countries = response
                promise.fulfill()
            }
        self.viewModel?.viewWillAppearTrigger.send(())
        
        wait(for: [promise], timeout: 30)
        XCTAssertFalse(countries.isEmpty, "Countries Successful")
        XCTAssertFalse(countries[0].regions.isEmpty, "Regions Successful")
        XCTAssertFalse(countries[0].regions[0].branches.isEmpty, "Branches Successful")
    }
}
