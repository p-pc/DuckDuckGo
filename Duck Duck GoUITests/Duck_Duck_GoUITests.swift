//
//  Duck_Duck_GoUITests.swift
//  Duck Duck GoUITests
//
//  Created by Parthiban on 2/28/18.
//  Copyright © 2018 Ossum. All rights reserved.
//

import XCTest

class Duck_Duck_GoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        testItemSelection()
        
    }
    
    func testItemSelection() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Cosmo Kramer"]/*[[".cells.staticTexts[\"Cosmo Kramer\"]",".staticTexts[\"Cosmo Kramer\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Cosmo Kramer"].buttons["Seinfeld"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Jackie Chiles"]/*[[".cells.staticTexts[\"Jackie Chiles\"]",".staticTexts[\"Jackie Chiles\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Jackie Chiles"].buttons["Seinfeld"].tap()
        
        XCTAssert(true, "simple item selection works fine for initial launch")

        testSwitchView()

    }
    
    func testSwitchView() {
        
        
        let app = XCUIApplication()
        let gridswitchButton = app.navigationBars["Seinfeld"].buttons["gridswitch"]
        gridswitchButton.tap()
        gridswitchButton.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Jerry Seinfeld (character)"]/*[[".cells.staticTexts[\"Jerry Seinfeld (character)\"]",".staticTexts[\"Jerry Seinfeld (character)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        gridswitchButton.tap()
        
        let element = app.collectionViews.children(matching: .cell).element(boundBy: 1).children(matching: .other).element
        element.swipeUp()
        element.swipeDown()
        gridswitchButton.tap()
        
        XCTAssert(true, "switching list view and grid view works fine")
        
    }
    
}
