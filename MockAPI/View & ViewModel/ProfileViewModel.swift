import Foundation

extension ProfileView {
    @MainActor
    final class ProfileViewModel: ObservableObject {
        private let userID: EntityID<User>
        private var tweetRepository: TweetRepositoryProtocol
        @Published private(set) var tweets: [Tweet]?
        @Published private(set) var isReady = false
        @Published private(set) var isWorking = false
        @Published private(set) var isEditMode = false
        @Published private(set) var deleteTargetTweets = Set<EntityID<Tweet>>()
        
        func isDeleteTarget(_ id: EntityID<Tweet>) -> Bool {
            deleteTargetTweets.contains(id)
        }
        
        init(_ userID: EntityID<User>, tweetRepository: TweetRepositoryProtocol) {
            self.userID = userID
            self.tweetRepository = tweetRepository
        }
        
        func onApearAction() async {
            tweets = try? await tweetRepository.get(userID: userID)
            isReady = true
        }
        
        func didRetryButtonTappedAction() {
            guard isWorking == false else { return }
            isWorking = true
            Task {
                defer { isWorking = false }
                tweets = try? await tweetRepository.get(userID: userID)
            }
        }
        
        func didTweetRowTapAction(id: EntityID<Tweet>) {
            guard isEditMode else { return }
            if deleteTargetTweets.contains(id) {
                deleteTargetTweets.remove(id)
            } else {
                deleteTargetTweets.insert(id)
            }
        }
        
        func didEditDoneButtonTapAction() {
            deleteTargetTweets.removeAll()
            isEditMode = false
        }
        
        func didEditButtonTapAction() {
            isEditMode = true
        }
        
        func didDeleteButtonTapAction() {
            guard isWorking == false else { return }
            isWorking = true
            Task {
                defer { isWorking = false }
                await tweetRepository.removeTweets(ids: deleteTargetTweets)
                deleteTargetTweets.removeAll()
                isEditMode = false
                tweets = try? await tweetRepository.get(userID: userID)
            }
        }
    }
}
