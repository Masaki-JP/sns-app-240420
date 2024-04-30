import SwiftUI

struct TweetListView: View {
    @StateObject private var viewModel = TweetListViewModel(tweetRepository: isPreviewEnvironment ? InMemoryTweetRepository() : TweetRepository())
    @AppStorage("userName") private var userName = ""
    @AppStorage("userID") private var _userID = ""
    private var userID: EntityID<User> { .init(value: _userID) }
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: nil) {
                    if viewModel.isReady == true {
                        switch viewModel.tweets {
                        case .some(let tweets) where tweets.isEmpty == false:
                            ForEach(tweets) { tweet in
                                NavigationLink {
                                    TweetDetailView()
                                } label: {
                                    tweetRow(tweet)
                                }
                                .foregroundStyle(.primary)
                                Divider()
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
                .frame(maxWidth: 500)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
            }
            .navigationTitle("Tweet List")
            .navigationBarTitleDisplayMode(.inline)
            .refreshable { await viewModel.onRefreshAction() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Profile", systemImage: "slider.horizontal.3") {
                        viewModel.isShowingProfileView = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Post", systemImage: "paperplane") {
                        viewModel.isShowingPostTweetView = true
                    }
                }
            }
            .overlay {
                if viewModel.isWorking {
                    Color.primary.opacity(0.05)
                    ProgressView("Reloading...")
                }
            }
        }
        .adaptivePresentation(
            isPresented: $viewModel.isShowingProfileView,
            onDismiss: viewModel.onReappearAction,
            content: { ProfileView(userID) }
        )
        .adaptivePresentation(
            isPresented: $viewModel.isShowingPostTweetView,
            onDismiss: viewModel.onReappearAction,
            content: { PostTweetView() }
        )
        .task { await viewModel.onAppearAction() }
        .disabled(viewModel.isReady == false || viewModel.isWorking == true)
        .animation(.easeIn, value: viewModel.isReady)
        .animation(.easeIn, value: viewModel.isWorking)
        .onChange(of: scenePhase) { _, newScene in
            if newScene == .active { viewModel.onReappearAction() }
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
            Button(
                action: { viewModel.didTapRetryButton() } ,
                label: { Text("Retry").padding(.horizontal) }
            )
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
}

#Preview {
    ContentView()
}
