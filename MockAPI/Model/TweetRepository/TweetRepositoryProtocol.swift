import Foundation

// TweetRepositoryProtocol is defined only for Preview.
protocol TweetRepositoryProtocol {
    mutating func getAll() async throws -> [Tweet]
    mutating func get(userID: EntityID<User>) async throws -> [Tweet]
    func remove(ids: Set<EntityID<Tweet>>) async
}
