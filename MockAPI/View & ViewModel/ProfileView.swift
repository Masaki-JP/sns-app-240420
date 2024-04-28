import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    init(_ userID: EntityID<User>) {
        if isPreviewEnvironment {
            self._viewModel = StateObject(wrappedValue: ProfileViewModel(.init(value: "a"), tweetRepository: InMemoryTweetRepository()))
        } else {
            self._viewModel = StateObject(wrappedValue: ProfileViewModel(userID, tweetRepository: TweetRepository()))
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack { conditionalContent }
                    .frame(maxWidth: 500)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle(viewModel.isEditMode == false ? "Your Tweet List" : "Edit Mode")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: toolbarContent)
        }
        .task { await viewModel.onApearAction() }
        .animation(.easeIn, value: viewModel.isReady)
        .animation(.easeIn, value: viewModel.isWorking)
        .sensoryFeedback(.impact, trigger: viewModel.isEditMode)
        .sensoryFeedback(.decrease, trigger: viewModel.deleteTargetTweets)
    }

    @ViewBuilder
    var conditionalContent: some View {
        if viewModel.isReady == true, viewModel.isWorking == false {
            switch viewModel.tweets {
            case .some(let tweets) where tweets.isEmpty == false:
                ForEach(tweets) { tweet in
                    Button {
                        viewModel.didTweetRowTapAction(id: tweet.id)
                    } label: {
                        tweetRow(tweet, numberOfLineLimit: nil)
                            .overlay {
                                if viewModel.isDeleteTarget(tweet.id) {
                                    Color.primary.opacity(0.1)
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(.green)
                                }
                            }
                    }
                    .disabled(viewModel.isEditMode == false)
                    .foregroundStyle(.primary)
                }
            case .some:
                noContentView
                    .scaledToFit()
            case .none:
                retryPromptView
                    .scaledToFit()
            }
        } else {
            progressView
                .scaledToFit()
        }
    }

    var noContentView: some View {
        ContentUnavailableView("No Content", systemImage: "tray", description: Text("You haven't posted anything yet."))
    }

    var retryPromptView: some View {
        ContentUnavailableView(label: {
            Label("Error", systemImage: "exclamationmark.triangle")
        }, description: {
            Text("Something is wrong. Please, try again.")
        }, actions: {
            Button(action: viewModel.didRetryButtonTappedAction) {
                Text("Retry")
                    .padding(.horizontal)
            }
            .buttonStyle(.bordered)
        })
    }

    var progressView: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .overlay {
                ProgressView("Loading...")
            }
    }

    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if viewModel.isEditMode == true {
                Button("Done", action: viewModel.didEditDoneButtonTapAction)
                    .disabled(viewModel.isWorking)
            } else {
                Button("Edit", action: viewModel.didEditButtonTapAction)
                    .disabled(viewModel.isReady == false || viewModel.isWorking == true)
            }
        }
        ToolbarItem(placement: .topBarTrailing) {
            if viewModel.isEditMode == true {
                Button("Delete", action: viewModel.didDeleteButtonTapAction)
                    .tint(.red)
                    .disabled(viewModel.deleteTargetTweets.isEmpty || viewModel.isWorking)
            } else {
                Button("Done", action: dismiss.callAsFunction)
                    .disabled(viewModel.isWorking == true)
            }
        }
    }
}

private struct UserDetailViewWrapper: View {
    @State private var isShowingUserDetailView = true

    var body: some View {
        Color.orange.ignoresSafeArea()
            .fullScreenCover(isPresented: $isShowingUserDetailView) {
                ProfileView(EntityID<User>(value: "1"))
            }
    }
}

#Preview {
    UserDetailViewWrapper()
}
