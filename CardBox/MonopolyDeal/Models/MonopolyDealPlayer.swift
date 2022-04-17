//
//  MonopolyDealPlayers.swift
//  CardBox
//
//  Created by Temp on 31.03.2022.
//
import Foundation

class MonopolyDealPlayer: Player {
    static let maxPlayCount = 3

    private(set) var playCount = 0

    override init(name: String) {
        super.init(name: name)
    }

    init(name: String,
         id: UUID = UUID(),
         isOutOfGame: Bool = false,
         cardsPlayed: Int = 0,
         playCount: Int = 0) {
        self.playCount = playCount
        super.init(id: id, name: name, isOutOfGame: isOutOfGame, cardsPlayed: cardsPlayed)
    }

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

    func getPlayArea(gameRunner: GameRunnerProtocol) -> MonopolyDealPlayerPropertyArea? {
        guard let gameState = gameRunner.gameState as? MonopolyDealGameState else {
            return nil
        }
        return gameState.getPropertyArea(for: self)
    }

    override func playCards(_ cards: [Card], gameRunner: GameRunnerProtocol, on target: GameplayTarget) {
        guard let gameState = gameRunner.gameState as? MonopolyDealGameState else {
            return
        }

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
            MoveCardsDeckToDeckEvent(cards: mdCards, fromDeck: playerHand, toDeck: gameState.gameplayArea),
            IncrementPlayerPlayCountEvent(player: self)
        ])
    }

    override func determineTargetOfCards(_ cards: [Card], gameRunner: GameRunnerProtocol) -> TypeOfTargettedCard? {
        guard canPlay(cards: cards, gameRunner: gameRunner) else {
            return nil
        }

        switch cards.count {
        case 1:
            return cards[0].typeOfTargettedCard
        default:
            return nil
        }
    }

    private enum CodingKeys: String, CodingKey {
        case playCount
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.playCount = try container.decode(Int.self, forKey: .playCount)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(playCount, forKey: .playCount)
        try super.encode(to: encoder)
    }
}
