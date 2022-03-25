class TestCard: Card {
    var name: String
    var cardDescription: String
    var typeOfTargettedCard: TypeOfTargettedCard

    init(name: String, typeOfTargettedCard: TypeOfTargettedCard) {
        self.name = name
        self.typeOfTargettedCard = typeOfTargettedCard
        self.cardDescription = ""
    }

    // func onDraw<TestPlayer>(gameRunner: GameRunner<TestCard, TestPlayer>, player: TestPlayer) {

    // }

    // func onPlay(gameRunner: GameRunner<TestCard, TestPlayer>, player: TestPlayer, on target: GameplayTarget<TestPlayer>) {
        
    // }
}