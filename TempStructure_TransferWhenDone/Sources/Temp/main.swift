print("Hello, world!")
var g: GameRunner = TestGameRunner()

var card1 = TestCard(name: "card 1", typeOfTargettedCard: .noTargetCard)
var card2 = TestCard(name: "card 2", typeOfTargettedCard: .noTargetCard)

var cards = [card1, card2]
// g.addSetupAction(InitDeckWithCardsAction(cards: cards))
// g.addSetupAction(InitPlayerAction(numPlayers: 4))

// g.setup()

// print(g.deck.getCards())
