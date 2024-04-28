import Foundation

struct Tweet: Identifiable, Hashable {
    let id: EntityID<Self>
    let body: String
    let user: User?
    let postedTime: Date

    static func == (lhs: Tweet, rhs: Tweet) -> Bool {
        return lhs.id == rhs.id
    }
}
