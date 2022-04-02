import Foundation
import UniformTypeIdentifiers
enum GameplayTarget {
    case all
    case none
    case single(Player)
    case deck(CardCollection)

    var description: String {
        switch self {
        case .all:
            return "all"
        case .none:
            return "none"
        case .single:
            return "single"
        case .deck:
            return "deck"
        }
    }

    func getPlayerIfTargetSingle() -> Player? {
        switch self {
        case let .single(targetPlayer):
            return targetPlayer
        case .all, .none, .deck:
            return nil
        }
    }

    func getDeckIfTargetSingle() -> CardCollection? {
        switch self {
        case let .deck(collection):
            return collection
        case .all, .none, .single:
            return nil
        }
    }
}

enum TypeOfTargettedCard: String, Codable {
    case targetAllPlayersCard
    case targetSinglePlayerCard
    case targetSingleDeckCard
    case noTargetCard
}

class Card: NSObject, Identifiable {
    let id: UUID
    let name: String
    let cardDescription: String
    let typeOfTargettedCard: TypeOfTargettedCard

    override var description: String {
        String(UInt(bitPattern: ObjectIdentifier(self)))
    }

    init(
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        cardDescription: String = ""
    ) {
        self.id = UUID()
        self.name = name
        self.typeOfTargettedCard = typeOfTargettedCard
        self.cardDescription = ""
    }

    init(
        id: UUID,
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        cardDescription: String = ""
    ) {
        self.id = id
        self.name = name
        self.typeOfTargettedCard = typeOfTargettedCard
        self.cardDescription = ""
    }

    // Convenience function for testing
    convenience init(name: String) {
        self.init(name: name, typeOfTargettedCard: .noTargetCard)
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let other = object as? Card {
            return self.id == other.id
        } else {
            return false
        }
    }

    // To be overwritten
    func onDraw(gameRunner: GameRunnerProtocol, player: Player) {

    }

    // To be overwritten
    func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {

    }
}
