import Foundation

// UserRepositoryProtcol is defined only for Preview.
protocol UserRepositoryProtcol: AnyObject {
    func fetch(_ id: EntityID<User>) async throws -> User?
    func fetch(_ ids: Set<EntityID<User>>) async throws -> [User]
}
