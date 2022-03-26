class TestPlayer: Player {
    let name: String
    let isOutOfGame = false
    let cardsPlayed: Int = 0
    let cardCollectionIndexes: Set<Int> = Set()

    init(name: String) {
        self.name = name
    }
}
