//
//  MainMenuView_UITests.swift
//  CardBoxUITests
//
//  Created by Bernard Wan on 19/3/22.
//

import XCTest

class MainMenuView_UITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation
        // - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_MainMenuView_PlayOfflineButton_shouldLaunchGame() {
        XCUIApplication().buttons["LaunchOfflineGame"].tap()

        let playerNameText = app.buttons["Current Player: Player 1"]
        XCTAssertTrue(playerNameText.exists)
    }

}
