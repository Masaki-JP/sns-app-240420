import Foundation

final class InMemoryUserRepository: UserRepositoryProtcol {
    func fetch(_ id: EntityID<User>) async throws -> User? {
        guard users.filter({ $0.id == id }).count == 1,
              let user = users.filter({ $0.id == id }).first
        else { fatalError() }
        return user
    }

    func fetch(_ ids: Set<EntityID<User>>) async throws -> [User] {
        return ids.map { id in
            guard users.filter({ $0.id == id }).count == 1,
                  let user = users.filter({ $0.id == id }).first
            else { fatalError() }
            return user
        }
    }

    private let users: [User] = [
        .init(id: .init(value: "a"), name: "Sako" ),
        .init(id: .init(value: "b"), name: "Seigetsu"),
        .init(id: .init(value: "c"), name: "Maki"),
        .init(id: .init(value: "d"), name: "Tomo"),
        .init(id: .init(value: "e"), name: "Hinakko")
    ]
}
