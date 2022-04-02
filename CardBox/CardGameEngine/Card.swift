import Foundation
import UniformTypeIdentifiers
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

enum TypeOfTargettedCard: Codable {
    case targetAllPlayersCard
    case targetSinglePlayerCard
    case noTargetCard
}

class Card: NSObject, Identifiable {
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
        self.name = name
        self.typeOfTargettedCard = typeOfTargettedCard
        self.cardDescription = ""
    }

    // Convenience function for testing
    convenience init(name: String) {
        self.init(name: name, typeOfTargettedCard: .noTargetCard)
    }

    // To be overwritten
    func onDraw(gameRunner: GameRunnerProtocol, player: Player) {

    }

    // To be overwritten
    func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {

    }
}
