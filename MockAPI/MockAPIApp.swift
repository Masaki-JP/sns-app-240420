import SwiftUI

@main
struct MockAPIApp: App {
    @AppStorage("userName") private var userName = ""
    @AppStorage("userID") private var _userID = ""
//    private var userID: EntityID<User> { .init(value: _userID) }
    private var isSignUpCompleted: Bool {
        userName.isEmpty == false && _userID.isEmpty == false
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if isSignUpCompleted {
                    ContentView()
                } else {
                    SignUpView()
                }
            }
            .animation(.easeIn, value: isSignUpCompleted)
        }
    }
}
