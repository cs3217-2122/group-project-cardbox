//
//  GameRunnerView_UITests.swift
//  CardBoxUITests
//
//  Created by Bernard Wan on 19/3/22.
//

import XCTest

class GameRunnerView_UITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        try super.setUpWithError()
        app.launchArguments = ["-UITest_ExplodingKittens"]
        app.launch()
        XCUIApplication().buttons["LaunchOfflineGame"].tap()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_GameRunnerView_EndButton_shouldGoToNextPlayer() {

        let endButton = app.buttons["End"]
        let player1 = app.buttons["Current Player: Player 1"]
        let player2 = app.buttons["Player 2"]

        XCTAssertTrue(endButton.exists)
        XCTAssertTrue(player1.exists)
        XCTAssertTrue(player2.exists)

        endButton.tap()

        let currentPlayer = app.buttons["Current Player: Player 2"]
        XCTAssertTrue(currentPlayer.exists)
    }

    func test_GameRunnerView_PlaySkip_shouldGoToNextPlayer() {
        let playButton = app.buttons["Play"]
        let skipCard = app.staticTexts["Skip"]
        let emptyPlayDeck = app.staticTexts["No card in stack"]

        skipCard.tap()
        playButton.tap()

        let currentPlayer = app.buttons["Current Player: Player 2"]
        XCTAssertFalse(emptyPlayDeck.exists)
        XCTAssertTrue(currentPlayer.exists)
    }

    func test_GameRunnerView_PlayInvalidCombo_shouldDoNothing() {
        let playButton = app.buttons["Play"]
        let skipCard = app.staticTexts["Skip"]
        let shuffleCard = app.staticTexts["Shuffle"]
        let emptyPlayDeck = app.staticTexts["No card in stack"]

        XCTAssertTrue(emptyPlayDeck.exists)

        skipCard.tap()
        shuffleCard.tap()
        playButton.tap()

        XCTAssertTrue(emptyPlayDeck.exists)
    }

    func test_GameRunnerView_SeeTheFuture_shouldPopUpView() {
        let endButton = app.buttons["End"]
        for _ in 0...4 {
            endButton.tap()
        }

        let seeTheFuture = app.staticTexts["See The Future"]
        seeTheFuture.tap()
        app.buttons["Play"].tap()

        let random2 = app.staticTexts["Random 2"]
        XCTAssertTrue(random2.exists)

        let popoverDismiss = app.otherElements["PopoverDismissRegion"].firstMatch
        popoverDismiss.tap()

        // let doesNotExist = NSPredicate(format: "exists == FALSE")
        // expectation(for: doesNotExist, evaluatedWith: random1)
        // waitForExpectations(timeout: 3.0)
        XCTAssertFalse(random2.exists)

        let emptyPlayDeck = app.staticTexts["No card in stack"]
        XCTAssertFalse(emptyPlayDeck.exists)
    }

}
