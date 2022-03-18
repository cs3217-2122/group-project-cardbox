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

    func getPlayerIfTargetSingle() -> Player? {
        switch self {
        case let .single(targetPlayer):
            return targetPlayer
        case .all, .none:
            return nil
        }
    }
}

typealias CardPlayCondition = (_ gameRunner: GameRunnerReadOnly, _ player: Player, _ target: GameplayTarget) -> Bool

class Card: Identifiable, ExtendedProperties {
    private(set) var name: String
    private(set) var cardDescription: String

    private var onDrawActions: [CardAction]
    private var onPlayActions: [CardAction]

    private var canPlayConditions: [CardPlayCondition]
    internal var additionalParams: [String: String]

    var description: String {
        String(UInt(bitPattern: ObjectIdentifier(self)))
    }

    init(name: String) {
        self.name = name
        self.cardDescription = ""
        self.onDrawActions = []
        self.onPlayActions = []
        self.canPlayConditions = []
        self.additionalParams = [:]
    }

    func addDrawAction(_ action: CardAction) {
        self.onDrawActions.append(action)
    }

    func addPlayAction(_ action: CardAction) {
        self.onPlayActions.append(action)
    }

    func onDraw(gameRunner: GameRunnerReadOnly, player: Player) {
        let args = CardActionArgs(card: self, player: player, target: .none)

        self.onDrawActions.forEach { action in
            action.executeGameEvents(gameRunner: gameRunner, args: args)
        }
    }

    func onPlay(gameRunner: GameRunnerReadOnly, player: Player, on target: GameplayTarget) {
        let args = CardActionArgs(card: self, player: player, target: target)

        self.onPlayActions.forEach { action in
            action.executeGameEvents(gameRunner: gameRunner, args: args)
        }
    }
}
