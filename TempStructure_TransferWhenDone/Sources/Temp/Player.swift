protocol Player: Equatable, AnyObject {
    var name: String { get }
    var isOutOfGame: Bool { get }
    var cardsPlayed: Int { get }
    var cardCollectionIndexes: Set<Int> { get }
}

extension Player {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs === rhs
    }
}
