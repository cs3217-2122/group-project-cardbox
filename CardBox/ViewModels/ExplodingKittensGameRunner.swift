//
//  ExplodingKittensGameRunner.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//

class ExplodingKittensGameRunner: GameRunner {
    // To be overwritten
    override func checkWinningConditions() -> Bool {
        false
    }

    override func setup() {
        let numPlayers = 4
        
        let players = (1...numPlayers).map { i in
            ExplodingKittensPlayer(name: "Player " + i.description)
        }
        let playerEvents: [GameEvent] = players.map { player in
            AddPlayerEvent(player: player)
        } + [
            SetCurrentPlayerEvent(player: players[0])
        ]

        // Distribute defuse cards
        let defuseCards: [Card] = (0..<numPlayers).map { _ in DefuseCard() }
        let defuseCardEvents: [GameEvent] = defuseCards.indices.map { i in
            AddCardToPlayerEvent(card: defuseCards[i], player: players[i])
        }

        let cards = initCards()
        let initCardEvents: [GameEvent] = cards.map { card in
            AddCardToDeckEvent(card: card)
        }
        
        let shuffleEvent: GameEvent = ShuffleDeckEvent()
        
        executeGameEvents(
            playerEvents +
            defuseCardEvents +
            initCardEvents +
            [shuffleEvent]
        )
        
        let initialCardCount = 4
        // TODO: Have common actions here, to be reused by multiple
    }
    
    private func initCards() -> [Card] {
        var cards: [Card] = []
        
//        for _ in 0 ..< ExplodingKittensCardType.favor.initialFrequency {
//            cards.append(generateFavorCard())
//        }

        for _ in 0 ..< ExplodingKittensCardType.attack.initialFrequency {
            cards.append(AttackCard())
        }

        for _ in 0 ..< ExplodingKittensCardType.shuffle.initialFrequency {
            cards.append(ShuffleCard())
        }

//        for _ in 0 ..< ExplodingKittensCardType.skip.initialFrequency {
//            cards.append(generateSkipCard())
//        }

        for _ in 0 ..< ExplodingKittensCardType.seeTheFuture.initialFrequency {
            cards.append(SeeTheFutureCard())
        }

//        for _ in 0 ..< ExplodingKittensCardType.random1.initialFrequency {
//            cards.append(generateRandom1Card())
//            cards.append(generateRandom2Card())
//            cards.append(generateRandom3Card())
//        }

        return cards
    }

    // To be overwritten
    override func onStartTurn() {

    }

    // To be overwritten
    override func onEndTurn() {

    }

    // To be overwritten
    override func onAdvanceNextPlayer() {

    }

    // To be overwritten
    override func getWinner() -> Player? {
        nil
    }

    // To be overwritten
    override func getNextPlayer() -> Player? {
        guard !players.isEmpty else {
            return nil
        }

        guard let currentPlayer = players.currentPlayer as? ExplodingKittensPlayer else {
            return nil
        }

        let attackCount = currentPlayer.attackCount
        if attackCount > 0 {
            return currentPlayer
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

    var allCardTypes: [ExplodingKittensCardType] {
        ExplodingKittensConstants.allCardTypes
    }

    func dispatchDeckPositionResponse(offsetFromTop: Int) {
        guard let args = deckPositionRequestArgs else {
            return
        }

//        ActionDispatcher.runAction(
//            DeckPositionResponseAction(
//                card: args.card,
//                player: args.player,
//                offsetFromTop: offsetFromTop
//            ),
//            on: self
//        )
    }

    func dispatchPlayerHandPositionResponse(playerHandPosition: Int) {
        guard let args = playerHandPositionRequestArgs else {
            return
        }

//        ActionDispatcher.runAction(
//            PlayerHandPositionResponseAction(target: args.target,
//                                             player: args.player,
//                                             playerHandPosition: playerHandPosition),
//            on: self
//        )
    }

    func dispatchCardTypeResponse(cardTypeRawValue: String) {
        guard let args = cardTypeRequestArgs else {
            return
        }

//        ActionDispatcher.runAction(
//            CardTypeResponseAction(target: args.target,
//                                   player: args.player,
//                                   cardTypeRawValue: cardTypeRawValue),
//            on: self)
    }

}
