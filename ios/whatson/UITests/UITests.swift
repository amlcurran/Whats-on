//
//  UITests.swift
//  UITests
//
//  Created by Alex Curran on 01/02/2023.
//  Copyright © 2023 Alex Curran. All rights reserved.
//

import XCTest

final class UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        let element = app.scrollViews.children(matching: .other).element(boundBy: 0).children(matching: .other).element
        element.children(matching: .staticText).matching(identifier: "Nothing on").element(boundBy: 0).tap()
        app.textFields["Title"].typeText("Foo")
        app.staticTexts["Location or Video Call"].tap()
        app.searchFields.element(boundBy: 0).tap()
        app.searchFields.element(boundBy: 0).typeText("Oxford Circus")
        app.staticTexts["Oxford Circus Station"].tap()
        app.navigationBars["New Event"].buttons["Add"].tap()
        
        XCTAssertTrue(app.staticTexts["Foo"].isHittable)
        XCTAssertTrue(app.staticTexts["From 5:00pm"].exists)
        app.staticTexts["Foo"].tap()
        
        XCTAssertTrue(app.staticTexts["From 5:00pm to 11:00pm"].exists)
//        element.tap()
//        element.tap()
        
                
    }

}
