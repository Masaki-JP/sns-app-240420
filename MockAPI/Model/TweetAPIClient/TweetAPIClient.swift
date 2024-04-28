import Foundation

struct TweetAPIClient {
    struct TweetDTO: Codable {
        let id: String?
        let body: String
        let postedBy: String
        let createdAt: Int
    }

    private struct UserDTO: Codable {
        let id: String?
        let name: String
    }

    func fetchAll() async throws -> [TweetDTO] {
        let url = URL(string: baseURL + "/tweets")!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode != 404
        else { return [] }
        return try JSONDecoder().decode([TweetDTO].self, from: data)
    }

    func fetch(userID: EntityID<User>) async throws -> [TweetDTO] {
        let url = URL(string: baseURL + "/tweets?postedBy=" + userID.value)!
        let (data, response) = try await URLSession.shared.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode != 404
        else { return [] }
        return try JSONDecoder().decode([TweetDTO].self, from: data)
    }

    func createTweet(userName: String, userID: EntityID<User>, text: String) async throws {
        let tweetDTO = TweetDTO(id: nil, body: text, postedBy: userID.value, createdAt: Int(Date().timeIntervalSince1970))
        let tweetData = try JSONEncoder().encode(tweetDTO)
        let url = URL(string:  baseURL + "/tweets")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = tweetData
        let _ = try await URLSession.shared.data(for: request)
        try await Task.sleep(for: .seconds(1))
    }

    func deleteTweets(_ ids: Set<EntityID<Tweet>>) async {
        // measures against APIRL
        for id in ids {
            do {
                try await deleteTweet(id)
            } catch {
                print("💥", id); print(error);
            }
        }
        //        await withTaskGroup(of: Void.self) { taskGroup in
        //            for id in ids {
        //                taskGroup.addTask {
        //                    do {
        //                        try await deleteTweet(id)
        //                    } catch {
        //                        print("💥", id); print(error);
        //                    }
        //                }
        //            }
        //        }
    }

    func deleteTweet(_ id: EntityID<Tweet>) async throws {
        let url = URL(string: baseURL + "/tweets/" + id.value)!
        var reqest = URLRequest(url: url)
        reqest.httpMethod = "DELETE"
        let _ = try await URLSession.shared.data(for: reqest)
        try! await Task.sleep(for: .seconds(0.3))
    }
}
