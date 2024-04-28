import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TweetListView()
                .tabItem { Label("Home", systemImage: "house.fill") }
            Text("Coming soon...")
                .tabItem { Label("Notifications", systemImage: "bell.fill") }
            Text("Coming soon...")
                .tabItem { Label("Favorites", systemImage: "star.fill") }
            Text("Coming soon...")
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
        }
    }
}

#Preview {
    ContentView()
}
