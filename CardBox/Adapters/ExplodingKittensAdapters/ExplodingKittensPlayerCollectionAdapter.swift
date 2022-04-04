//
//  ExplodingKittensPlayerCollectionAdapter.swift
//  CardBox
//
//  Created by Stuart Long on 3/4/22.
//

class ExplodingKittensPlayerCollectionAdapter: PlayerCollectionAdapter {
    private var players: [ExplodingKittensPlayerAdapter]
    private var currentPlayerIndex: Int

    var playerCollection: PlayerCollection {
        var output: [Player] = []
        for player in players {
            output.append(player.gamePlayer)
        }
        return PlayerCollection(players: output, currentPlayerIndex: currentPlayerIndex)
    }

    var names: [String] {
        self.players.map { $0.name }
    }

    var count: Int {
        self.players.count
    }

    private enum CodingKeys: String, CodingKey {
        case players
        case currentPlayerIndex
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.players = try container.decode([ExplodingKittensPlayerAdapter].self, forKey: .players)
        self.currentPlayerIndex = try container.decode(Int.self, forKey: .currentPlayerIndex)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(players, forKey: .players)
        try container.encode(currentPlayerIndex, forKey: .currentPlayerIndex)
    }

    init(_ playerCollection: PlayerCollection) {
        self.players = []
        for player in playerCollection.getPlayers() {
            if let player = player as? ExplodingKittensPlayer {
                self.players.append(
                    ExplodingKittensPlayerAdapter(player))
            }
        }
        self.currentPlayerIndex = playerCollection.currentPlayerIndex
    }

    func getExplodingKittensPlayerAdapterByName(name: String) -> ExplodingKittensPlayerAdapter? {
        for player in players where player.name == name {
            return player
        }
        return nil
    }

    func remove(_ player: Player) {
        if let index = players.firstIndex(where: { $0.id == player.id }) {
            players.remove(at: index)
        }
        for player in players {
            print(player.name)
        }
    }

    func addPlayer(_ player: ExplodingKittensPlayer) {
        guard !players.contains(where: { $0.id == player.id }) else {
            return
        }

        self.players.append(ExplodingKittensPlayerAdapter(player))
    }

    func getPlayerByIndex(_ index: Int) -> ExplodingKittensPlayerAdapter? {
        guard index >= 0 && index < players.count else {
            return nil
        }

        return players[index]
    }
}
