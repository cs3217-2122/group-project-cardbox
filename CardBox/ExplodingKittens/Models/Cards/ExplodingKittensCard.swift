//
//  ExplodingKittensCard.swift
//  CardBox
//
//  Created by mactest on 25/03/2022.
//
import Foundation

class ExplodingKittensCard: Card {
    typealias EKGameRunnerProtocol = ExplodingKittensGameRunnerProtocol
    typealias EKPlayer = ExplodingKittensPlayer

    let type: ExplodingKittensCardType

    init(
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        type: ExplodingKittensCardType,
        cardDescription: String = ""
    ) {
        self.type = type
        super.init(
            name: name,
            typeOfTargettedCard: typeOfTargettedCard,
            cardDescription: cardDescription
        )
    }

    init(
        id: UUID,
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        type: ExplodingKittensCardType,
        cardDescription: String = ""
    ) {
        self.type = type
        super.init(
            id: id,
            name: name,
            typeOfTargettedCard: typeOfTargettedCard,
            cardDescription: cardDescription
        )
    }

    override final func onDraw(gameRunner: GameRunnerProtocol, player: Player) {
        guard let ekGameRunner = gameRunner as? EKGameRunnerProtocol else {
            return
        }

        guard let ekPlayer = player as? EKPlayer else {
            return
        }

        onDraw(gameRunner: ekGameRunner, player: ekPlayer)
    }

    func onDraw(gameRunner: EKGameRunnerProtocol, player: EKPlayer) {

    }

    override final func onPlay(gameRunner: GameRunnerProtocol, player: Player, on target: GameplayTarget) {
        guard let ekGameRunner = gameRunner as? EKGameRunnerProtocol else {
            return
        }

        guard let ekPlayer = player as? EKPlayer else {
            return
        }

        onPlay(gameRunner: ekGameRunner, player: ekPlayer, on: target)
    }

    // To be overridden
    func onPlay(gameRunner: EKGameRunnerProtocol, player: EKPlayer, on target: GameplayTarget) {
    }

    private enum CodingKeys: String, CodingKey {
        case type
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(ExplodingKittensCardType.self, forKey: .type)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
//        let superEncoder = container.superEncoder()
        try super.encode(to: encoder)
    }
}
