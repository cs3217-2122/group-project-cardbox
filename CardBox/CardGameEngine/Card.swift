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

class Card: NSObject, Identifiable, Codable {
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

extension Card: NSItemProviderWriting, NSItemProviderReading {
    static var readableTypeIdentifiersForItemProvider: [String] {
        ["cardbox.card"]
    }

    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
        let decoder = JSONDecoder()
        do {
            let json = try decoder.decode(Self.self, from: data)
            return json
        } catch {
            fatalError("Error decoding")
        }
    }

    static var uti = UTType("cardbox.card") ?? .data

    static var writableTypeIdentifiersForItemProvider: [String] {
        ["cardbox.card"]
    }

    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void)
    -> Progress? {
        let progress = Progress(totalUnitCount: 100)

        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            let json = String(data: data, encoding: String.Encoding.utf8)
            progress.completedUnitCount = 100
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return progress
    }
}
