import Foundation

struct TweetRepository: TweetRepositoryProtocol {
    private let userRepository = UserRepository.shared

    mutating func getAll() async throws -> [Tweet] {
        let tweetDTOs: [TweetAPIClient.TweetDTO] = try await TweetAPIClient().fetchAll()
        let uniqueUserIDs = Set(tweetDTOs.map { EntityID<User>(value: $0.postedBy) })
        let users = try await userRepository.fetch(uniqueUserIDs)
        let tweets: [Tweet] = tweetDTOs.compactMap { tweetDTO in
            guard let idString = tweetDTO.id else { return nil }
            let user: User? =
            if users.filter({ $0.id == .init(value: tweetDTO.postedBy) }).count == 1,
               let user = users.filter({ $0.id == .init(value: tweetDTO.postedBy) }).first { user }
            else { nil }
            return .init(id: .init(value: idString), body: tweetDTO.body, user: user, postedTime: .init(timeIntervalSince1970: .init(tweetDTO.createdAt)))
        }
        try! await Task.sleep(for: .seconds(1))
        return tweets.sorted(by: { $0.postedTime > $1.postedTime })
    }

    mutating func get(userID: EntityID<User>) async throws -> [Tweet] {
        let tweetDTOs = try await TweetAPIClient().fetch(userID: userID)
        let user = try await userRepository.fetch(userID)
        let tweets: [Tweet] = tweetDTOs.compactMap { tweetDTO in
            guard let idString = tweetDTO.id else { return nil }
            return .init(id: .init(value: idString), body: tweetDTO.body, user: user, postedTime: .init(timeIntervalSince1970: .init(tweetDTO.createdAt)))
        }
        try! await Task.sleep(for: .seconds(1))
        return tweets.sorted(by: { $0.postedTime > $1.postedTime })
    }

    func create(userName: String, userID: EntityID<User>, text: String) async throws {
        guard await UserAPIClient().authenticateUser(userName: userName, userID: userID)
        else { throw TweetRepositoryError.invalidUser }
        try await TweetAPIClient().createTweet(userName: userName, userID: userID, text: text)
    }

    func removeTweets(ids: Set<EntityID<Tweet>>) async {
        await TweetAPIClient().deleteTweets(ids)
    }

    enum TweetRepositoryError: Error { case invalidUser }
}
