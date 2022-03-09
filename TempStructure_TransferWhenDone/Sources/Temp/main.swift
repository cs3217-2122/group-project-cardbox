print("Hello, world!")
var g: GameRunner = GameRunner()

var card1: Card = Card(name: "card 1")
var card2: Card = Card(name: "card 2")

var card

var cards = [card1, card2]
g.addSetupAction(InitDeckWithCardsAction(cards: cards))
g.addSetupAction(InitPlayerAction(numPlayers: 4))

g.setup()

print(g.deck.getCards())
