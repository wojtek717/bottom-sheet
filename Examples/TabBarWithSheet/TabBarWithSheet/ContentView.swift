import SwiftUI
import BottomSheet
import MapKit

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .toolbarBackground(.visible, for: .tabBar)

                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .toolbarBackground(.visible, for: .tabBar)
            }
        }
    }
}

struct HomeView: View {
    @State private var showCustomSheet = true
    
    var body: some View {
        ZStack {
            Map { }
            .bottomSheet(isPresented: $showCustomSheet) {
                List {
                    Section("Favorites") {
                        HStack(spacing: 20) {
                            FavoriteView(action: {}, image: Image(systemName: "house.fill"), title: "Home")
                            FavoriteView(action: {}, image: Image(systemName: "briefcase.fill"), title: "Work")
                            FavoriteView(action: {}, image: Image(systemName: "fuelpump.fill"), title: "Gas")
                            FavoriteView(action: {}, image: Image(systemName: "plus"), title: "Add")
                        }
                    }
                    
                    Section("Recents") {
                        RecentView(
                            title: "Market Square",
                            subtitle: "Rynek, 11-400 Wrocław",
                            image: Image(systemName: "arrow.turn.up.right"))
                        
                        RecentView(
                            title: "Wrocław University of Science and Technology",
                            subtitle: "Wybrzeże Stanisława Wyspiańskiego 27, 50-370 Wrocław",
                            image: Image(systemName: "mappin"))
                        
                        RecentView(
                            title: "Sky Tower",
                            subtitle: "Powstańców Śląskich 95, 53-332 Wrocław",
                            image: Image(systemName: "arrow.turn.up.left"))
                    }
                }
            }
            .detentsPresentation(detents: [.small, .medium, .large])
            .ignoresSafeAreaEdgesPresentation(nil)
            .dragIndicatorPresentation(isVisible: true)
        }
    }
}

#Preview(body: {
    ContentView()
})

struct FavoriteView: View {
    let action: () -> ()
    let image: Image
    let title: String
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.lightGray)
                    .overlay {
                        image
                    }
                
                Text(title)
                    .font(.footnote)
                    .foregroundStyle(Color.black)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct RecentView: View {
    let title: String
    let subtitle: String
    let image: Image
    
    var body: some View {
        HStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.lightGray)
                .overlay {
                    image
                }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(Color.gray)
            }
        }
    }
}
