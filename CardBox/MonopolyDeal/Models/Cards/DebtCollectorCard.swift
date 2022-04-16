//
//  DebtCollectorCard.swift
//  CardBox
//
//  Created by Bryann Yeap Kok Keong on 16/4/22.
//

class DebtCollectorCard: MonopolyDealCard {
    let debtCollectionAmount: Int = 5

    init() {
        super.init(
            name: "Debt Collector",
            typeOfTargettedCard: .targetSinglePlayerCard,
            type: .debtCollector
        )
    }

    override func onPlay(gameRunner: MDGameRunnerProtocol, player: MDPlayer, on target: GameplayTarget) {
        guard let targetPlayer = target.getPlayerIfTargetSingle() as? MonopolyDealPlayer else {
            return
        }

        gameRunner.executeGameEvents([RequestForMoneyEvent(moneyAmount: debtCollectionAmount,
                                                           requestDescription: "Owe money pay money! "
                                                           + "Please pay \(player.name) \(debtCollectionAmount) M.",
                                                           requestSender: player,
                                                           requestReciepient: targetPlayer)])
    }

    override func getBankValue() -> Int {
        guard let bankValue = MonopolyDealCardType.debtCollector.bankValue else {
            assert(false, "Unable to obtain bank value of debt collector card")
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
