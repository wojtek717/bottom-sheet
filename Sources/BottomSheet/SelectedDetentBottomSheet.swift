//
//  SelectedDetentBottomSheet.swift
//  BottomSheet
//
//  Created by Sam Doggett on 10/28/24.
//


import SwiftUI

struct SelectedDetentBottomSheet<Content: View, SheetContent: View>: BottomSheet {
    @State var configuration: BottomSheetViewConfiguration

    @Binding var selectedDetent: Detent

    private let content: Content
    private let sheetContent: SheetContent

    public init(
        configuration: BottomSheetViewConfiguration = .init(),
        selectedDetent: Binding<Detent>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
        self.configuration = configuration
        self._selectedDetent = selectedDetent
        self.content = content()
        self.sheetContent = sheetContent()
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            content.frame(maxWidth: .infinity)

            if selectedDetent != .hidden {
                BottomSheetView(
                    configuration: $configuration,
                    selectedDetent: $selectedDetent,
                    content: sheetContent
                )
            }
        }
    }
}

private struct ExampleView: View {

    @State var selectedDetent = Detent.small

    var isPresented: Bool {
        selectedDetent != .hidden
    }

    var body: some View {
        TabView {
            Tab("Map", systemImage: "map") {
                VStack {
                    Text("isPresented: \(isPresented.description)")
                    Button(selectedDetent == .hidden ? "Show `BottomSheet`" : "Hide `BottomSheet`") {
                        selectedDetent = if selectedDetent == .hidden {
                            .small
                        } else {
                            .hidden
                        }
                    }
                }
                .bottomSheet(selectedDetent: $selectedDetent) {
                    RainbowList()
                }
                .dragIndicatorPresentation(isVisible: true)
                // We can prevent the user from swiping to dismiss by excluding `hidden` from
                // this list, while still supporting hiding it programmatically. Alternatively,
                // add `.hidden` to this list to allow users to swipe to dismiss.
                .detentsPresentation(detents: [.small, .medium, .large])
            }

            Tab("Settings", systemImage: "gear") {
                Text("Settings")
            }
        }
    }

}

#Preview {
    ExampleView()
}
