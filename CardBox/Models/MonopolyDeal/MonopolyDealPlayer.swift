//
//  MonopolyDealPlayers.swift
//  CardBox
//
//  Created by Temp on 31.03.2022.
//

class MonopolyDealPlayer: Player {
    static let maxPlayCount = 3

    private(set) var playCount = 0

    func incrementPlayCount() {
        self.playCount += 1
    }

    func resetPlayCount() {
        self.playCount = 0
    }

    override func canPlay(cards: [Card], gameRunner: GameRunnerProtocol) -> Bool {
        let mdCards = cards.compactMap { $0 as? MonopolyDealCard }

        guard !mdCards.isEmpty else {
            return false
        }

        guard self.playCount < MonopolyDealPlayer.maxPlayCount else {
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

        gameRunner.executeGameEvents([
            MoveCardsDeckToDeckEvent(cards: mdCards, fromDeck: playerHand, toDeck: mdGameRunner.gameplayArea),
            IncrementPlayerPlayCountEvent(player: self)
        ])
    }

    private static func playPairCombo() {
    }
}
