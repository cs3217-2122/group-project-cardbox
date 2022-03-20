//
//  IncrementAdditionalParamsEvent.swift
//  CardBox
//
//  Created by mactest on 19/03/2022.
//

struct StepAdditionalParamsEvent: GameEvent {
    let extendedProperty: ExtendedProperties
    let key: String
    let step: Int

    init(extendedProperty: ExtendedProperties, key: String, step: Int = 1) {
        self.extendedProperty = extendedProperty
        self.key = key
        self.step = step
    }

    func updateRunner(gameRunner: GameRunnerUpdateOnly) {
        let value = extendedProperty.getAdditionalParams(key: key) ?? "0"

        guard let valueInt = Int(value) else {
            return
        }

        let newValue = max(0, valueInt + step)

        extendedProperty.setAdditionalParams(key: key, value: String(newValue))
    }
}
