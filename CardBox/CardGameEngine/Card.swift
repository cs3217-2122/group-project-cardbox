enum GameplayTarget {
    case all
    case none
    case single(Player)

    var description: String {
        switch self {
        case .all:
            return "all"
        case .none:
            return "none"
        case .single:
            return "single"
        }
    }
}

typealias PlayCondition = (_ gameRunner: GameRunnerReadOnly, _ player: Player, _ target: GameplayTarget) -> Bool

class Card: Identifiable {
    private(set) var name: String
    private var cardDescription: String

    private var onDrawActions: [CardAction]
    private var onPlayActions: [CardAction]

    private var canPlayConditions: [PlayCondition]

    init(name: String) {
        self.name = name
        self.cardDescription = ""
        self.onDrawActions = []
        self.onPlayActions = []
        self.canPlayConditions = []
    }

    func addDrawAction(_ action: CardAction) {
        self.onDrawActions.append(action)
    }

    func addPlayAction(_ action: CardAction) {
        self.onPlayActions.append(action)
    }

    func onDraw(gameRunner: GameRunnerReadOnly, player: Player) {
        self.onDrawActions.forEach { action in
            action.executeGameEvents(gameRunner: gameRunner, player: player, target: .none)
        }
    }

    func onPlay(gameRunner: GameRunnerReadOnly, player: Player, on target: GameplayTarget) {
        self.onPlayActions.forEach { action in
            action.executeGameEvents(gameRunner: gameRunner, player: player, target: target)
        }
    }

    func canPlay(by player: Player, gameRunner: GameRunnerReadOnly, on target: GameplayTarget) -> Bool {
        canPlayConditions.allSatisfy({ $0(gameRunner, player, target) })
    }
}
