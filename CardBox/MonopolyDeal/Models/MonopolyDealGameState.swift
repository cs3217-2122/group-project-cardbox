//
//  MonopolyDealGameState.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

import Foundation

class MonopolyDealGameState: GameState {
    internal var deck: CardCollection
    internal var playerPropertyArea: [UUID: MonopolyDealPlayerPropertyArea]
    internal var playerMoneyArea: [UUID: CardCollection]
    internal var gameplayArea: CardCollection

    override init() {
        self.deck = CardCollection()
        self.playerPropertyArea = [:]
        self.playerMoneyArea = [:]
        self.gameplayArea = CardCollection()
        super.init()
    }

    private enum CodingKeys: String, CodingKey {
        case deck
        case playerPropertyArea
        case playerMoneyArea
        case gameplayArea
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deck = try container.decode(CardCollection.self, forKey: .deck)
        self.playerPropertyArea = try container.decode([UUID: MonopolyDealPlayerPropertyArea].self,
                                                       forKey: .playerPropertyArea)
        self.playerMoneyArea = try container.decode([UUID: CardCollection].self, forKey: .playerMoneyArea)
        self.gameplayArea = try container.decode(CardCollection.self, forKey: .gameplayArea)
        try super.init(from: decoder)
    }

    override func updateState(gameState: GameState) {
        if let gameState = gameState as? MonopolyDealGameState {
            if gameState.state == .start {
                self.deck.updateState(gameState.deck)
                self.gameplayArea.updateState(gameState.gameplayArea)
            } else {
                self.deck = gameState.deck
                self.playerPropertyArea = gameState.playerPropertyArea
                self.playerMoneyArea = gameState.playerMoneyArea
                self.gameplayArea = gameState.gameplayArea
            }
        }

        super.updateState(gameState: gameState)
    }

    func checkIfPropertySetIsFullSet(_ propertySet: CardCollection) -> Bool {
        let pureProperties = propertySet
            .getCards()
            .filter({ $0 is PropertyCard })

        guard let baseCard = pureProperties.first as? PropertyCard else {
            return false
        }

        return pureProperties.count == baseCard.setSize &&
        pureProperties.contains(where: { card in
            guard let propertyCard = card as? PropertyCard else {
                return false
            }
            return propertyCard.colors.count == 1
        })
    }

    private func updatePlayerPropertyArea(_ newPlayerProperyArea: [UUID: MonopolyDealPlayerPropertyArea]) {
        for (key, value) in newPlayerProperyArea {
            guard let current = playerPropertyArea[key] else {
                continue
            }
            current.updateState(value)
        }
    }

    private func updatePlayerMoneyArea(_ newPlayerMoneyArea: [UUID: CardCollection]) {
        for (key, value) in newPlayerMoneyArea {
            guard let current = playerMoneyArea[key] else {
                continue
            }
            current.updateState(value)
        }
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(playerPropertyArea, forKey: .playerPropertyArea)
        try container.encode(playerMoneyArea, forKey: .playerMoneyArea)
        try container.encode(gameplayArea, forKey: .gameplayArea)
        try super.encode(to: encoder)
    }
}
