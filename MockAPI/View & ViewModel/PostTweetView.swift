import SwiftUI

struct PostTweetView: View {
    @StateObject private var viewModel = PostTweetViewModel()
    @State private var text = ""
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            TextEditor(text: $text)
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
                            viewModel.didTapCancelButton(dismiss.callAsFunction)
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
                        Button("Post") { viewModel.didTapPostButton(dismiss.callAsFunction) }
                    }
                }
                .onAppear { isFocused = true }
        }
        .disabled(viewModel.isWorking)
        .sync($text, with: $viewModel.text)
        .alert("Error occurred.", isPresented: $viewModel.isShowingAlert) {
            Button("OK") {}
        }
    }
}

/// This extention is for the following warning.
/// Publishing changes from within view updates is not allowed, this will cause undefined behavior.
private extension View {
    func sync(_ published: Binding<String>, with binding: Binding<String>) -> some View {
        self
            .onChange(of: published.wrappedValue) { oldValue, newValue in
                guard oldValue != newValue,
                      published.wrappedValue != binding.wrappedValue
                else { return }
                binding.wrappedValue = newValue
            }
            .onChange(of: binding.wrappedValue) { oldValue, newValue in
                guard oldValue != newValue,
                      published.wrappedValue != binding.wrappedValue
                else { return }
                published.wrappedValue = newValue
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
