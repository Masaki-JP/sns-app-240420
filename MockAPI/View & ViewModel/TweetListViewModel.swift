import Foundation

extension TweetListView {
    @MainActor
    final class TweetListViewModel: ObservableObject {
        private var tweetRepository: TweetRepositoryProtocol
        @Published private(set) var tweets: [Tweet]?
        @Published private(set) var isReady = false
        @Published private(set) var isWorking = false
        @Published var isShowingProfileView = false
        @Published var isShowingPostTweetView = false

        init(tweetRepository: TweetRepositoryProtocol) {
            self.tweetRepository = tweetRepository
        }

        func onAppearAction() async {
            if isReady == false {
                defer { isReady = true }
                tweets = try? await tweetRepository.getAll()
            } else {
                onReappearAction()
            }
        }

        func onReappearAction() {
            guard isReady == true, isWorking == false else { return }
            isWorking = true
            Task {
                defer { isWorking = false }
                tweets = try? await tweetRepository.getAll()
            }
        }

        func refreshAction() async {
            tweets = try? await tweetRepository.getAll()
        }
        
        func didTapRetryButton() {
            guard isWorking == false else { return }
            isWorking = true
            Task {
                defer { isWorking = false }
                tweets = try? await tweetRepository.getAll()
            }
        }
    }
}
