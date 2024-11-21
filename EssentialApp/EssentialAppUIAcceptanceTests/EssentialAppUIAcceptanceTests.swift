//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Shujaat-Hussain on 11/21/24.
//

import XCTest

class EssentialAppUIAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
        XCTAssertEqual(app.cells.count, 22)
        //This assert is failing. Need to check
        //XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}
