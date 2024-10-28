//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

public struct BottomSheet<Content: View, SheetContent: View>: View {
    @State var configuration = BottomSheetViewConfiguration()

    @Binding var selectedDetent: Detent

    private let content: Content
    private let sheetContent: SheetContent

    public init(
        selectedDetent: Binding<Detent>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
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

public extension View {

    func bottomSheet<SheetContent: View>(
        selectedDetent: Binding<Detent>,
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> BottomSheet<Self, SheetContent> {
        BottomSheet(
            selectedDetent: selectedDetent,
            content: { self },
            sheetContent: sheetContent
        )
    }

}

private struct ExampleView: View {
    @State var selectedDetent = Detent.small

    var isPresented: Bool {
        selectedDetent != .hidden
    }

    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]

    @ViewBuilder
    var rainbowList: some View {
        List {
            ForEach((0..<colors.count * 4), id: \.self) { index in
                let color = colors[index % colors.count]
                Text(color.description)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowBackground(color)
            }
        }
        .listStyle(.plain)
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
                    rainbowList
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

