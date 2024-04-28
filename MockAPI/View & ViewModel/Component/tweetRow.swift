import SwiftUI

/// ⚠️ This view's maxWidth is infinity.
/// - Parameter numberOfLineLimit: The line limit. If `nil`, no line limit applies.
func tweetRow(_ tweet: Tweet, numberOfLineLimit lineLimit: Int? = 3) -> some View {
    VStack(spacing: 10) {
        HStack(spacing:0) {
            Color.pink.frame(width: 3)
            Text(tweet.user?.name ?? "unknown")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 5)
                .padding(.vertical, -1.5)
        }
        .padding(.vertical, 1.5)
        Text(tweet.body)
            .lineLimit(lineLimit)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        Text(tweet.postedTime, format: .dateTime.year().month().day().hour().minute())
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
