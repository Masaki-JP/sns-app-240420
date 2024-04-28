import Foundation

final class User: Identifiable, Hashable {
    let id: EntityID<User>
    let name: String

    init(id: EntityID<User>, name: String) {
        self.id = id
        self.name = name
    }
    
    func hash(into hasher: inout Hasher) {
        id.hash(into: &hasher)
        name.hash(into: &hasher)
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
