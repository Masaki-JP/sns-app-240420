import Foundation

struct InMemoryTweetRepository: TweetRepositoryProtocol {
    func getAll() async throws -> [Tweet] {
        var tweets = getTweets()
        tweets.sort(by: { $0.postedTime > $1.postedTime })
        return tweets
    }

    func get(userID: EntityID<User>) async throws -> [Tweet] {
        return getTweets().filter { $0.user!.id == userID }
    }

    func removeTweets(ids: Set<EntityID<Tweet>>) async {
        fatalError("InMemoryTweetRepository exist only for Preview.")
    }

    let sako = User(id: .init(value: "a"), name: "Sako")
    let seigetsu = User(id: .init(value: "b"), name: "Seigetsu")
    let maki = User(id: .init(value: "c"), name: "Maki")
    let tomo = User(id: .init(value: "d"), name: "Tomo")
    let hinakko = User(id: .init(value: "e"), name: "Hinakko")

    func getTweets() -> [Tweet] {
        [
            .init(id: .init(value: "a"), body: "今日もいい天気だな〜", user: sako, postedTime: .init(timeIntervalSinceNow: -1)),
            .init(id: .init(value: "b"), body: "来週iPhone買おうかな〜", user: sako, postedTime: .init(timeIntervalSinceNow: -2)),
            .init(id: .init(value: "c"), body: "今日は寒いな〜", user: seigetsu, postedTime: .init(timeIntervalSinceNow: -3)),
            .init(id: .init(value: "d"), body: "来月iPad買おうかな〜", user: seigetsu, postedTime: .init(timeIntervalSinceNow: -4)),
            .init(id: .init(value: "e"), body: "花粉が飛んでるな〜", user: maki, postedTime: .init(timeIntervalSinceNow: -5)),
            .init(id: .init(value: "f"), body: "来年MacBook買おうかな〜", user: maki, postedTime: .init(timeIntervalSinceNow: -6)),
            .init(id: .init(value: "g"), body: "雪降らないかな〜", user: tomo, postedTime: .init(timeIntervalSinceNow: -7)),
            .init(id: .init(value: "h"), body: "明日AirPods買おうかな〜", user: tomo, postedTime: .init(timeIntervalSinceNow: -8)),
            .init(id: .init(value: "i"), body: "今日はSwiftUIについて勉強した！", user: hinakko, postedTime: .init(timeIntervalSinceNow: -9)),
            .init(id: .init(value: "j"), body: "今日はSwift Concurrencyについて勉強した！", user: hinakko, postedTime: .init(timeIntervalSinceNow: -10)),
            .init(id: .init(value: "k"), body: "今日はAPI通信について勉強した！", user: hinakko, postedTime: .init(timeIntervalSinceNow: -11))
        ]
    }
}
