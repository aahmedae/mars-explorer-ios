//
//  Mars_ExplorerUITests.swift
//  Mars ExplorerUITests
//
//  Created by Asad Ahmed on 8/4/17.
//  Copyright © 2017 Asad Ahmed. All rights reserved.
//

import XCTest

class Mars_ExplorerUITests: XCTestCase
{
    // MARK:- Constants
    
    fileprivate let HOME_FIELD_TITLES = ["Landing Date", "Launch Date", "Status"]
    fileprivate let CURIOSITY_MANIFEST_INFO = ["2012-08-06", "2011-11-26", "active"]
    
    // MARK:- Setup
    
    override func setUp()
    {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()

        // landscape mode only for this app
        XCUIDevice.shared().orientation = .landscapeRight
    }
    
    // MARK:- Home VC Tests
    
    // Test out UI after start button tapped
    func testStartExperience()
    {
        let app = XCUIApplication()
        app.buttons["START"].tap()
        
        // wait for the rover panel to show up
        waitForRoverPanel(app: app)
    }
    
    // Test out UI for selecting a rover
    func testRoverSelection()
    {
        XCUIDevice.shared().orientation = .landscapeRight
        
        let app = XCUIApplication()
        app.buttons["START"].tap()
        
        waitForRoverPanel(app: app)
        app.buttons["Rover Icon A "].tap()
        
        // verify UI has changed and is visible
        for i in 0 ... HOME_FIELD_TITLES.count - 1
        {
            let fieldtext = "\(HOME_FIELD_TITLES[i]): \(CURIOSITY_MANIFEST_INFO[i])"
            XCTAssert(app.staticTexts[fieldtext].exists)
        }
    }
    
    // MARK:- Private Functions
    
    // Wait max for 10 seconds for the rover panel to show up
    fileprivate func waitForRoverPanel(app: XCUIApplication)
    {
        var roverPanelVisible = false
        var timeWaited = 0
        
        while !roverPanelVisible
        {
            if timeWaited >= 10 {
                XCTFail("UI waiting too long for rover panel to show up")
            }
            
            Thread.sleep(forTimeInterval: 1)
            roverPanelVisible = (app.staticTexts["Curiosity"].exists && app.staticTexts["Opportunity"].exists && app.staticTexts["Spirit"].exists)
            timeWaited += 1
        }
    }
}
