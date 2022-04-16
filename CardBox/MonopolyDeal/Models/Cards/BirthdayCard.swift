//
//  BirthdayCard.swift
//  CardBox
//
//  Created by user213938 on 4/3/22.
//

class BirthdayCard: MonopolyDealCard {
    let birthdayAmount: Int = 2

    init() {
        super.init(
            name: "Birthday",
            typeOfTargettedCard: .targetAllPlayersCard,
            type: .birthday
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard case .all = target else {
            return
        }

        let players = gameRunner.gameState.players.getPlayers().filter({ $0 !== player })

        players.forEach {
            guard let targetPlayer = $0 as? MonopolyDealPlayer else {
                return
            }
            gameRunner.executeGameEvents([RequestForMoneyEvent(moneyAmount: birthdayAmount,
                                                               requestDescription: "Its " + player.name +
                                                               "'s birthday. Please pay him/her \(birthdayAmount) M.",
                                                               requestSender: player,
                                                               requestReciepient: targetPlayer)])
        }
    }

    override func getBankValue() -> Int {
        guard let bankValue = MonopolyDealCardType.birthday.bankValue else {
            assert(false, "Unable to obtain bank value of birthday card")
        }
        return bankValue
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
    }
}
