import Foundation

// UserRepositoryProtcol is defined only for Preview.
protocol UserRepositoryProtcol: AnyObject {
    func get(_ id: EntityID<User>) async throws -> User?
    func get(_ ids: Set<EntityID<User>>) async throws -> [User]
}
