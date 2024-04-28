import Foundation

struct UserAPIClient {
    private struct UserDTO: Codable {
        let id: String?
        let name: String
    }

    enum UserAPIClientError: Error { case createFailure }

    func fetch(_ id: EntityID<User>) async throws -> User? {
        let url = URL(string: baseURL + "/users/" + id.value)!
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let userDTO = try? JSONDecoder().decode(UserDTO.self, from: data)
        else { return nil }
        return .init(name: userDTO.name, id: userDTO.id)
    }

    func create(userName: String) async -> Result<(userName: String, userID: String), UserAPIClientError> {
        guard
            userName.isEmpty == false,
            let url = URL(string: baseURL + "/users"),
            let (data, _) = try? await URLSession.shared.data(from: url),
            let allUsers = try? JSONDecoder().decode([UserDTO].self, from: data),
            allUsers.map(\.name).contains(userName) == false,
            let userJsonData = try? JSONEncoder().encode(UserDTO(id: nil, name: userName)),
            let request = createURLRequest(url, data: userJsonData),
            let (data, _) = try? await URLSession.shared.data(for: request),
            let userDTO = try? JSONDecoder().decode(UserDTO.self, from: data),
            let id = userDTO.id
        else { return .failure(.createFailure) }
        return .success((userName: userDTO.name, userID: id))
    }

    private func createURLRequest(_ url: URL?, data: Data?) -> URLRequest? {
        guard let url, let data else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        return request
    }

    func authenticateUser(userName: String, userID: EntityID<User>) async -> Bool {
        guard let url = URL(string: baseURL + "/users/" + userID.value),
              let (data, _) = try? await URLSession.shared.data(from: url),
              let user = try? JSONDecoder().decode(UserDTO.self, from: data)
        else { return false }
        return (userName, userID.value) == (user.name, user.id)
    }
}

private extension User {
    convenience init?(name: String, id: String?) {
        guard let id else { return nil }
        self.init(id: .init(value: id), name: name)
    }
}
