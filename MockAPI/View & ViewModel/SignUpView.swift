import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            Text("What's your name?")
                .foregroundStyle(.white)
                .font(.title2)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("", text: $viewModel.text)
                .focused($isFocused)
                .padding(5)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.top, 7.5)
            Button("Sign Up") { viewModel.didSignUpButtonTappedAction() }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .fontWeight(.semibold)
                .tint(.orange)
                .padding(.top, 15)
        }
        .disabled(viewModel.isWorking)
        .frame(maxWidth: 500)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: colorScheme == .light ? [.blue, .cyan] : [.indigo, .blue], startPoint: .topLeading, endPoint: .bottomLeading))
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("完了") { isFocused = false }
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .alert("Sign up failed.", isPresented: $viewModel.isShowSignUpFailureAlert) {
            Button("OK") {}
        }
    }
}


#Preview {
    SignUpView()
}
