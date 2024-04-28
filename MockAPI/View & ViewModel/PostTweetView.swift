import SwiftUI

struct PostTweetView: View {
    @StateObject private var viewModel = PostTweetViewModel()
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            TextEditor(text: $viewModel.text)
                .focused($isFocused)
                .navigationTitle("What are you doing?")
                .navigationBarTitleDisplayMode(.inline)
                .overlay {
                    if viewModel.isWorking {
                        ProgressView("Posting...")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            viewModel.didCancelButtonTappedAction(dismiss.callAsFunction)
                        }
                        .confirmationDialog(
                            "Are you sure?",
                            isPresented: $viewModel.isShowingConfirmationDialog,
                            titleVisibility: .visible
                        ) {
                            Button("Discard Changes", role: .destructive, action: dismiss.callAsFunction)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Post") { viewModel.didPostButtonTappedAction(dismiss.callAsFunction) }
                    }
                }
                .onAppear { isFocused = true }
        }
        .disabled(viewModel.isWorking)
        .alert("Error occurred.", isPresented: $viewModel.isShowingAlert) {
            Button("OK") {}
        }
    }
}

struct PostTweetViewWrapper: View {
    @State private var isShowingPostTweetView = true

    var body: some View {
        Text("Hello, world")
            .fullScreenCover(isPresented: $isShowingPostTweetView) {
                PostTweetView()
            }
    }
}

#Preview {
    PostTweetViewWrapper()
}
