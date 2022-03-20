//
//  ActionTests+NextPlayerGeneratorStub.swift
//  CardBoxTests
//
//  Created by Bryann Yeap Kok Keong on 20/3/22.
//

@testable import CardBox

extension ActionTests {

    struct NextPlayerGeneratorStub: NextPlayerGenerator {
        func getNextPlayer(gameRunner: GameRunnerReadOnly) -> Player? {
            let players = gameRunner.players

            guard !players.isEmpty else {
                return nil
            }

            let currentIndex = players.currentPlayerIndex
            let totalCount = players.count
            var nextPlayer: Player?

            for i in 1...totalCount {
                let nextIndex = (currentIndex + i) % totalCount

                guard let player = players.getPlayerByIndex(nextIndex) else {
                    continue
                }

                if player.isOutOfGame {
                    continue
                }

                nextPlayer = player
                break
            }

            return nextPlayer
        }
    }

    func getAndSetupGameRunnerInstance() -> GameRunner {
        gameRunner = GameRunner()

        // Init actions are not tested
        gameRunner.addSetupAction(
            InitPlayerAction(
                numPlayers: numOfPlayers,
                canPlayConditions: [],
                cardCombos: [cardCombo]
            )
        )

        gameRunner.addSetupAction(
            InitDeckWithCardsAction(cards: [
                generateSingleTargetCard(),
                generateSingleTargetCard(),
                generateAllTargetCard(),
                generateAllTargetCard(),
                generateNoTargetCard(),
                generateNoTargetCard()
            ])
        )

        gameRunner.setNextPlayerGenerator(NextPlayerGeneratorStub())

        ActionDispatcher.runAction(SetupGameAction(),
                                   on: gameRunner)
        return gameRunner
    }

    func generateSingleTargetCard() -> Card {
        let card = Card(name: "Single Target",
                        typeOfTargettedCard: .targetSinglePlayerCard)
        card.setAdditionalParams(key: cardTypeKey,
                                 value: "single-target")
        return card
    }

    func generateAllTargetCard() -> Card {
        let card = Card(name: "All Target",
                        typeOfTargettedCard: .targetAllPlayersCard)
        card.setAdditionalParams(key: cardTypeKey,
                                 value: "all-target")
        return card
    }

    func generateNoTargetCard() -> Card {
        let card = Card(name: "No Target",
                        typeOfTargettedCard: .noTargetCard)
        card.setAdditionalParams(key: cardTypeKey,
                                 value: "no-target")
        return card
    }
}
