//
//  IsPresentedBottomSheet.swift
//  BottomSheet
//
//  Created by Sam Doggett on 10/28/24.
//

import SwiftUI

struct IsPresentedBottomSheet<Content: View, SheetContent: View>: BottomSheet {
    @State var configuration: BottomSheetViewConfiguration

    @State var selectedDetent: Detent = .small

    @Binding var isPresented: Bool

    private let content: Content
    private let sheetContent: SheetContent

    public init(
        configuration: BottomSheetViewConfiguration = .init(),
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
        self.configuration = configuration
        self._isPresented = isPresented
        self.content = content()
        self.sheetContent = sheetContent()
    }

    public var body: some View {
        SelectedDetentBottomSheet(
            configuration: configuration,
            selectedDetent: $selectedDetent,
            content: { content },
            sheetContent: { sheetContent }
        ).onChange(of: isPresented) { _, newValue in
            selectedDetent = isPresented ? .small : .hidden
        }
    }
    
}

private struct ExampleView: View {

    @State var isPresented: Bool = true

    var body: some View {
        TabView {
            Tab("Messages", systemImage: "message") {
                VStack {
                    Text("isPresented: \(isPresented.description)")
                    Button(isPresented ? "Show `BottomSheet`" : "Hide `BottomSheet`") {
                        isPresented.toggle()
                    }
                }
                .bottomSheet(isPresented: $isPresented) {
                    RainbowList()
                }
                .dragIndicatorPresentation(isVisible: true)
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

