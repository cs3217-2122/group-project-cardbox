//
//  RentCard.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/4/22.
//

class RentCard: ActionCard {
    typealias MDGameRunnerProtocol = MonopolyDealGameRunnerProtocol
    typealias MDPlayer = MonopolyDealPlayer

    let colors: Set<PropertyColor>

    private let standardNumOfColors: Int = 2

    init(colors: Set<PropertyColor>) {
        self.colors = colors

        let name = "Rent"
        let type = MonopolyDealCardType.rent

        if colors.count > standardNumOfColors {
            super.init(
                name: name,
                typeOfTargettedCard: .targetSinglePlayerCard
            )
        } else {
            super.init(
                name: name,
                typeOfTargettedCard: .targetAllPlayersCard
            )
        }
    }

    var isRentWildcard: Bool {
        colors.count > standardNumOfColors
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        var targetPlayers: [Player] = []

        if isRentWildcard {
            guard let targetPlayer = target.getPlayerIfTargetSingle() else {
                return
            }
            targetPlayers = [targetPlayer]
        } else {
            guard case .all = target else {
                return
            }
            targetPlayers = gameRunner.gameState.players.getPlayers().filter({ $0 !== player })
        }

        targetPlayers.forEach {
            guard let mdTargetPlayer = $0 as? MDPlayer else {
                assert(false, "Non monopoly deal player found in Monopoly Deal game")
            }

            let options = getStringRepresentationOfOptions(player: player, gameRunner: gameRunner)
            let requestDescription = "Pick 1 property set you'd like to call your rent on " +
            "(Note: If there are no options, it means that none of your property sets are valid for this rent card)"
            let optionsRequest = OptionsRequest(description: requestDescription,
                                                fromPlayer: player,
                                                toPlayer: player,
                                                callback: makeCallback(player: player,
                                                                       reciepient: mdTargetPlayer,
                                                                       gameRunner: gameRunner),
                                                stringRepresentationOfOptions: options)
            gameRunner.executeGameEvents([SendRequestEvent(request: optionsRequest)])
        }

        let hand = gameRunner.getHandByPlayer(player)
        gameRunner.executeGameEvents([MoveCardsDeckToDeckEvent(cards: [self],
                                                               fromDeck: hand,
                                                               toDeck: gameRunner.gameplayArea)])
    }

    private func makeCallback(player: MDPlayer, reciepient: MDPlayer, gameRunner: MDGameRunnerProtocol) -> Callback {

        let callback: (Response) -> Void = { response in
            guard let optionsResponse = response as? OptionsResponse else {
                return
            }

            let deckIndex = (Int(optionsResponse.value) ?? 0) - 1
            let propertyArea = gameRunner.getPropertyAreaByPlayer(player)

            guard deckIndex >= 0, deckIndex < propertyArea.count else {
                return
            }

            let chosenDeck = propertyArea.getArea()[deckIndex]
            guard let propertyCard = propertyArea.getFirstPropertyCardFromSet(chosenDeck) else {
                return
            }
            let rentAmount = propertyCard.getRentForSetSize(size: chosenDeck
                                                                .getCards()
                                                                .filter({ $0 is PropertyCard })
                                                                .count)
            gameRunner.executeGameEvents([
                MoneyRequestEvent(moneyAmount: rentAmount,
                                  requestDescription: "Time to pay rent! Please pay \(rentAmount)M to \(player.name)!",
                                  requestSender: player,
                                  requestReciepient: reciepient)
            ])

        }

        return Callback(callback)
    }

    private func getStringRepresentationOfOptions(player: MDPlayer, gameRunner: MDGameRunnerProtocol) -> [String] {
        var deckIndexOptions: [String] = []
        let propertyArea = gameRunner.getPropertyAreaByPlayer(player)
        let decks = propertyArea.getArea()
        for i in 0..<decks.count {
            let possibleDeck = decks[i]

            guard let propertyCard = propertyArea.getFirstPropertyCardFromSet(possibleDeck) else {
                continue
            }
            guard let baseColor = propertyCard.colors.first else {
                continue
            }

            if self.colors.contains(baseColor) {
                deckIndexOptions.append(String(i + 1))
            }
        }
        return deckIndexOptions
    }

    override func getBankValue() -> Int {
        if isRentWildcard {
            return 3
        } else {
            return 1
        }
    }

    private enum CodingKeys: String, CodingKey {
        case colors
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.colors = try container.decode(Set<PropertyColor>.self, forKey: .colors)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colors, forKey: .colors)
        try super.encode(to: encoder)
    }
}
