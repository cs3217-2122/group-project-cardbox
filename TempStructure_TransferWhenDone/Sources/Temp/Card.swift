enum GameplayTarget<V: Player> {
    case all
    case none
    case single(V)

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

    func getPlayerIfTargetSingle() -> V? {
        switch self {
        case let .single(targetPlayer):
            return targetPlayer
        case .all, .none:
            return nil
        }
    }
}

enum TypeOfTargettedCard {
    case targetAllPlayersCard
    case targetSinglePlayerCard
    case noTargetCard
}

protocol Card: Identifiable, AnyObject {
    var name: String { get }
    var cardDescription: String { get }
    var typeOfTargettedCard: TypeOfTargettedCard { get }

    // func onDraw<V: Player>(gameRunner: GameRunner<Self, V>, player: V)
    // func onPlay<V: Player>(gameRunner: GameRunner<Self, V>, player: V, on target: GameplayTarget<V>)
}
