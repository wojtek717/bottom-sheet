import SwiftUI
import BottomSheet

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
    @State private var showCustomSheet = false
    @State private var text = "1"
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text(text)
                Button("Add to text") {
                    text.append("2")
                    
                    if text.count > 10 {
                        text = "1"
                    }
                }
                
                Text("Hello view!")
                    .font(.title)
                Text("👋")
                    .font(.title)
                
                Spacer()
            }
            .bottomSheet(isPresented: $showCustomSheet, detents: [.small, .medium]) {
                VStack {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget egestas augue, a varius odio. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Sed mattis dolor sed turpis luctus auctor. Nulla fermentum justo congue, efficitur dolor eu, bibendum nisi. Quisque feugiat convallis pharetra. Cras ornare arcu suscipit consequat sodales. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nulla scelerisque augue in condimentum efficitur. Aenean egestas gravida leo, nec mattis elit malesuada eu. Quisque et odio hendrerit, congue tortor at, cursus diam.")
                }
                .font(.title)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .overlay(
            Button(action: {
                showCustomSheet.toggle()
            }) {
                Text(showCustomSheet ? "Hide Sheet" : "Show Sheet")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            },
            alignment: .top
        )
    }
}

#Preview(body: {
    ContentView()
})
