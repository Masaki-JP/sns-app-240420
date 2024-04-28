import SwiftUI

struct TweetDetailView: View {
    @StateObject private var viewModel = TweetDetailViewModel()

    var body: some View {
        Text("Here is TweetDetailView!")
    }
}

#Preview {
    TweetDetailView()
}
