//
//  MonopolyDealGameState.swift
//  CardBox
//
//  Created by Stuart Long on 12/4/22.
//

import Foundation

class MonopolyDealGameState: GameState {
    internal var deck: MonopolyDealCardCollection
    internal var playerPropertyArea: [UUID: MonopolyDealPlayerPropertyArea]
    internal var playerMoneyArea: [UUID: MonopolyDealCardCollection]
    internal var gameplayArea: MonopolyDealCardCollection

    override init() {
        self.deck = MonopolyDealCardCollection(cards: [], isFaceUp: false)
        self.playerPropertyArea = [:]
        self.playerMoneyArea = [:]
        self.gameplayArea = MonopolyDealCardCollection(cards: [])
        super.init()
    }

    private enum CodingKeys: String, CodingKey {
        case players
        case playerHands
        case state
        case isWin
        case winner
        case globalRequests
        case globalResponses
        case deck
        case playerPropertyArea
        case playerMoneyArea
        case gameplayArea
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deck = try container.decode(MonopolyDealCardCollection.self, forKey: .deck)
        self.playerPropertyArea = try container.decode([UUID: MonopolyDealPlayerPropertyArea].self,
                                                       forKey: .playerPropertyArea)
        self.playerMoneyArea = try container.decode([UUID: MonopolyDealMoneyPile].self, forKey: .playerMoneyArea)
        self.gameplayArea = try container.decode(MonopolyDealCardCollection.self, forKey: .gameplayArea)
        let players = try container.decode(MonopolyDealPlayerCollection.self, forKey: .players)
        let playerHands = try container.decode([UUID: MonopolyDealCardCollection].self, forKey: .playerHands)
        let state = try container.decode(GameModeState.self, forKey: .state)
        let isWin = try container.decode(Bool.self, forKey: .isWin)
        let winner: MonopolyDealPlayer?
        if container.contains(.winner) {
            winner = try container.decode(MonopolyDealPlayer.self, forKey: .winner)
        } else {
            winner = nil
        }
        let globalRequests = try container.decode(RequestCollection.self, forKey: .globalRequests)
        let globalResponses = try container.decode(ResponseCollection.self, forKey: .globalResponses)

        super.init(players: players,
                   playerHands: playerHands,
                   isWin: isWin,
                   winner: winner,
                   state: state,
                   globalRequests: globalRequests,
                   globalResponses: globalResponses)
    }

    override func updateState(gameState: GameState) {
        if let gameState = gameState as? MonopolyDealGameState {
            self.deck.updateState(gameState.deck)
            self.gameplayArea.updateState(gameState.gameplayArea)
            self.updatePlayerMoneyArea(gameState.playerMoneyArea)
            self.updatePlayerPropertyArea(gameState.playerPropertyArea)
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

    func numberOfFullSets(player: Player) -> Int {
        guard let sets = playerPropertyArea[player.id] else {
            return 0
        }
        return sets.numberOfFullSets
    }

    private func updatePlayerPropertyArea(_ newPlayerProperyArea: [UUID: MonopolyDealPlayerPropertyArea]) {
        for (key, value) in newPlayerProperyArea {
            if let current = playerPropertyArea[key] {
                current.updateState(value)
            } else {
                playerPropertyArea[key] = value
            }
        }
    }

    private func updatePlayerMoneyArea(_ newPlayerMoneyArea: [UUID: MonopolyDealCardCollection]) {
        for (key, value) in newPlayerMoneyArea {
            if let current = playerMoneyArea[key] {
                current.updateState(value)
            } else {
                playerMoneyArea[key] = value
            }
        }
    }

    func getPropertyArea(for player: Player) -> MonopolyDealPlayerPropertyArea? {
        playerPropertyArea[player.id]
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(deck, forKey: .deck)
        try container.encode(playerPropertyArea, forKey: .playerPropertyArea)
        try container.encode(playerMoneyArea, forKey: .playerMoneyArea)
        try container.encode(gameplayArea, forKey: .gameplayArea)
        try super.encode(to: encoder)
    }

    override func addPlayer(player: Player) {
        self.players.addPlayer(player)
        self.playerHands[player.id] = MonopolyDealCardCollection()
        self.playerPropertyArea[player.id] = MonopolyDealPlayerPropertyArea()
        self.playerMoneyArea[player.id] = MonopolyDealMoneyPile()
    }
}
