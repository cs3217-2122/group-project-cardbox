//
//  GameRunnerInitOnly.swift
//  CardBox
//
//  Created by mactest on 15/03/2022.
//

protocol GameRunnerInitOnly {
    func addSetupAction(_ action: Action)
    func addStartTurnAction(_ action: Action)
    func addEndTurnAction(_ action: Action)

    func setNextPlayerGenerator(_ generator: NextPlayerGenerator)
}
