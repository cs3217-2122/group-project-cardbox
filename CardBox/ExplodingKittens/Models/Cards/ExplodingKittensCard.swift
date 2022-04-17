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

    override init(
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        cardDescription: String = ""
    ) {
        super.init(
            name: name,
            typeOfTargettedCard: typeOfTargettedCard,
            cardDescription: cardDescription
        )
    }

    override init(
        id: UUID,
        name: String,
        typeOfTargettedCard: TypeOfTargettedCard,
        cardDescription: String = ""
    ) {
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
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
