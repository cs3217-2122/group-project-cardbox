class Card {
    private var name: String
    private var cardDescription: String

    private var onDrawActions: [Action] = []

    init(name: String) {
        self.name = name
        self.cardDescription = ""
        self.onDrawActions = []
    }

    func addDrawAction(_ action: Action) {
        self.onDrawActions.append(action)
    }

    func onDraw(gameRunner: GameRunnerProtocol) -> [GameEvent] {
        let events = self.onDrawActions.map { action in
            action.generateGameEvents(gameRunner: gameRunner)
        }
        return events.flatMap { $0 }
    }
}
