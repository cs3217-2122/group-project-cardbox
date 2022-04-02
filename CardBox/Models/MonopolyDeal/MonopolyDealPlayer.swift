//
//  MonopolyDealPlayers.swift
//  CardBox
//
//  Created by Temp on 31.03.2022.
//

class MonopolyDealPlayer: Player {
    override func canPlay(cards: [Card], gameRunner: GameRunnerProtocol) -> Bool {
        let mdCards = cards.compactMap { $0 as? MonopolyDealCard }

        guard !mdCards.isEmpty else {
            return false
        }

        if mdCards.count == 1 {
            return true
        }

        return false
    }

    override func playCards(_ cards: [Card], gameRunner: GameRunnerProtocol, on target: GameplayTarget) {
        let mdCards = cards.compactMap { $0 as? MonopolyDealCard }

        guard !mdCards.isEmpty else {
            return
        }

        if mdCards.count == 1 {
            let card = mdCards[0]
            card.onPlay(gameRunner: gameRunner, player: self, on: target)
        }

        guard let mdGameRunner = gameRunner as? MonopolyDealGameRunnerProtocol else {
            return
        }

        let playerHand = mdGameRunner.getHandByPlayer(self)

        let moveCardsEvent = mdCards.map { card in
            MoveCardDeckToDeckEvent(card: card, fromDeck: playerHand, toDeck: mdGameRunner.gameplayArea)
        }

        gameRunner.executeGameEvents(moveCardsEvent)
    }

    private static func playPairCombo() {

    }
}
