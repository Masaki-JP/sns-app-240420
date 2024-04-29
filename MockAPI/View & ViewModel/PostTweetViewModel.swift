import SwiftUI

extension PostTweetView {
    @MainActor
    final class PostTweetViewModel: ObservableObject {
        @Published var text = ""
        @Published private(set) var isWorking = false
        @Published var isShowingAlert = false
        @Published var isShowingConfirmationDialog = false
        @AppStorage("userName") private var userName = ""
        @AppStorage("userID") private var _userID = ""
        private var userID: EntityID<User> { .init(value: _userID) }

        func didPostButtonTappedAction(_ dismissFunction: @escaping () -> Void) {
            guard text.isEmpty == false, isWorking == false
            else { return }
            isWorking = true
            Task {
                defer { isWorking = false }
                do {
                    try await TweetRepository().create(userName: userName, userID: userID, text: text)
                    dismissFunction()
                } catch {
                    if let error = error as? TweetRepository.TweetRepositoryError,
                       error == .invalidUser {
                        userName.removeAll(); _userID.removeAll();
                    }
                    print(error); isShowingAlert = true;
                }
            }
        }

        func didCancelButtonTappedAction(_ dismissFunction: @escaping () -> Void) {
            if text.isEmpty {
                dismissFunction()
            } else {
                isShowingConfirmationDialog = true
            }
        }
    }
}
