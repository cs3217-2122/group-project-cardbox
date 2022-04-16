//
//  RequestCollection.swift
//  CardBox
//
//  Created by user213938 on 4/15/22.
//

class RequestCollection: GameEngineCollection<Request> {
    override init(_ requests: [Request]) {
        super.init(requests)
    }

    convenience init() {
        self.init([])
    }

    enum ObjectTypeKey: CodingKey {
        case type
    }

    enum RequestType: String, Codable {
        case inputTextRequest
        case optionsRequest
        case intRequest
    }

    enum CodingKeys: CodingKey {
        case requests
    }

    static func decodeRequest(from decoder: Decoder, type: RequestType) -> Request? {
        switch type {
        case .inputTextRequest:
            return try? InputTextRequest(from: decoder)
        case .intRequest:
            return try? IntRequest(from: decoder)
        case .optionsRequest:
            return try? OptionsRequest(from: decoder)
        }
    }

    static func getTypeFromRequest(_ request: Request) -> RequestType? {
        switch request {
        case is InputTextRequest:
            return .inputTextRequest
        case is OptionsRequest:
            return .optionsRequest
        case is IntRequest:
            return .intRequest
        default:
            return nil
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objectsArray = try container.nestedUnkeyedContainer(forKey: CodingKeys.requests)

        var items = [Request]()
        var array = objectsArray
        while !array.isAtEnd {
            guard let object = try? array.nestedContainer(keyedBy: ObjectTypeKey.self) else {
                continue
            }

            guard let requestType = try? object.decode(
                RequestType.self,
                forKey: ObjectTypeKey.type
            ) else {
                continue
            }

            let decoder = try object.superDecoder()
            let request: Request? = RequestCollection.decodeRequest(from: decoder, type: requestType)
            if let request = request {
                items.append(request)
            }
        }

        super.init(items)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        var objectsArray = container.nestedUnkeyedContainer(forKey: CodingKeys.requests)
        getCollection().forEach { item in
            let type: RequestType? = RequestCollection.getTypeFromRequest(item)

            guard let type = type else {
                return
            }

            var object = objectsArray.nestedContainer(keyedBy: ObjectTypeKey.self)

            try? object.encode(type, forKey: ObjectTypeKey.type)

            let encoder = object.superEncoder()
            try? item.encode(to: encoder)
        }
    }
}
