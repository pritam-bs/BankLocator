//
//  NetworkTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
import Combine
@testable import BankLocator

class NetworkTest: XCTestCase {
    
    func testNetworkSuccess() {
        let promise = expectation(description: "Network Test Successful")
        var branch: [Branch] = []
        let estoniaPublisher: AnyPublisher<BranchList, AppError> = Network.shared.request(router: ApiRouter.estonia)
        let cancelable = estoniaPublisher
            .sink { (completion) in
                
            } receiveValue: { (response) in
                branch = response
                promise.fulfill()
            }
      
        wait(for: [promise], timeout: 30)
        XCTAssertFalse(branch.isEmpty, "Successful")
    }
}
