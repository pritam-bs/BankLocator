//
//  ApiRouterTest.swift
//  BankLocatorTests
//
//  Created by Pritam on 2/11/20.
//

import XCTest
@testable import BankLocator

class ApiRouterTest: XCTestCase {

    func testApiRouter() {
        let router = ApiRouter.estonia
        let urlEstonia = URL(string: "https://www.swedbank.ee/finder.json")
        XCTAssertEqual(router.url, urlEstonia)
        
        let routerLatvia = ApiRouter.latvia
        let urlLatvia = URL(string: "https://ib.swedbank.lv/finder.json")
        XCTAssertEqual(routerLatvia.url, urlLatvia)
        
        let routerLithuania = ApiRouter.lithuania
        let urlLithuania = URL(string: "https://ib.swedbank.lt/finder.json")
        XCTAssertEqual(routerLithuania.url, urlLithuania)
    }
}
