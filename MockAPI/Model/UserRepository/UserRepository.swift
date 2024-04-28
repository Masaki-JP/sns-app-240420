import Foundation

final class UserRepository: UserRepositoryProtcol {
    private var users: [User] = []
    private init() {}
    static let shared = UserRepository()

    func fetch(_ id: EntityID<User>) async throws -> User? {
        if users.contains(where: { $0.id == id }) {
            return users.filter { $0.id == id }.first!
        } else {
            guard let NewUser = try? await UserAPIClient().fetch(id)
            else { return nil }
            users.append(NewUser)
            return NewUser
        }
    }

    /// ⚠️ Ignore not found users.
    func fetch(_ ids: Set<EntityID<User>>) async throws -> [User] {
        let additionalUsers = try await withThrowingTaskGroup(of: User?.self) { taskGroup in
            for id in ids {
                guard self.users.contains(where: { $0.id.value == id.value }) == false
                else { continue }
                taskGroup.addTask {
                    try await UserAPIClient().fetch(id)
                }
            }
            var users = [User]()
            for try await user in taskGroup {
                guard let user else { continue }
                users.append(user)
            }
            return users
        }
        users.append(contentsOf: additionalUsers)
        var users = [User]()
        for id in ids {
            guard self.users.filter({ $0.id == id }).count == 1,
            let user = self.users.filter({ $0.id == id }).first
            else { continue }
            users.append(user)
        }
        return users
    }
}
