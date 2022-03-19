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
        let player1 = app.staticTexts["Current Player: Player 1"]
        let player2 = app.staticTexts["Player 2"]

        XCTAssertTrue(endButton.exists)
        XCTAssertTrue(player1.exists)
        XCTAssertTrue(player2.exists)
        
        endButton.tap()
        
        let currentPlayer = app.staticTexts["Current Player: Player 2"]
        XCTAssertTrue(currentPlayer.exists)
    }
    
    func test_GameRunnerView_PlaySkip_shouldGoToNextPlayer() {
        let playButton = app.buttons["Play"]
        let skipCard = app.staticTexts["Skip"]
        let emptyPlayDeck = app.staticTexts["No card in stack"]

        
        skipCard.tap()
        playButton.tap()
        
        let currentPlayer = app.staticTexts["Current Player: Player 2"]
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
    
    
    
    
    

}
