class GameRunner: GameRunnerProtocol {
    internal var deck: Deck
    internal var currentPlayer: Player?
    internal var players: [Player]

    private var onSetupActions: [Action]
    private var onGameplayActions: [Action]
    internal var state: GameState

    init() {
        self.deck = Deck()
        self.onSetupActions = []
        self.onGameplayActions = []

        self.players = []
        self.state = .initialize
    }

    func addSetupAction(_ action: Action) {
        self.onSetupActions.append(action)
    }

    func addGameplayAction(_ action: Action) {
        self.onGameplayActions.append(action)
    }
    
    func setup() {
        self.onSetupActions.forEach { action in
            let gameEvents = action.generateGameEvents(gameRunner: self)
            gameEvents.forEach { event in
                update(gameEvent: event)
            }
        }
    }

    func step() {
        self.onGameplayActions.forEach { action in
            let gameEvents = action.generateGameEvents(gameRunner: self)
            gameEvents.forEach { event in
                update(gameEvent: event)
            }
        }
    }

    func refreshGame() {
        // TODO: refresh game whenever new things added (?)
    }

    func update(gameEvent: GameEvent) {
        switch gameEvent {
        case .moveCardToPlayerFromDeck(let card, let deck, let player):
            player.addCard(card)
            deck.removeCard(card)
        case .addCardToDeck(let card, let deck):
            deck.addCard(card)
        case .displayMessage(let message):
            print(message)
        default:
            return
        }
    }
}
