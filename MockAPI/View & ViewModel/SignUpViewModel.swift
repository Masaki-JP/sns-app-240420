import SwiftUI

extension SignUpView {
    @MainActor
    final class SignUpViewModel: ObservableObject {
        @Published var text = ""
        @Published private(set) var isWorking = false
        @AppStorage("userName") private var userName = ""
        @AppStorage("userID") private var _userID = ""
        @Published var isShowSignUpFailureAlert = false

        func didSignUpButtonTappedAction() {
            guard isWorking == false else { return }
            isWorking = true
            Task {
                defer { isWorking = false }
                let result = await UserAPIClient().create(userName: text)
                if case .success(let user) = result {
                    userName = user.userName
                    _userID = user.userID
                } else {
                    isShowSignUpFailureAlert = true
                }
            }
        }
    }
}
