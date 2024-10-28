//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

public protocol BottomSheet: View {
    associatedtype Content: View
    associatedtype SheetContent: View

    var configuration: BottomSheetViewConfiguration { get set }
}

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

public extension View {

    /// Presents a sheet when a binding to a Boolean value that you provide is true.
    /// - Parameters:
    ///   - selectedDetent: A binding to a `Detent` value that determines how to present the sheet that you create in the modifier’s content closure.
    ///   - sheetContent: A closure that returns the content of the sheet.
    @ViewBuilder
    func bottomSheet<SheetContent: View>(
        selectedDetent: Binding<Detent>,
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> some BottomSheet {
        SelectedDetentBottomSheet(
            selectedDetent: selectedDetent,
            content: { self },
            sheetContent: sheetContent
        )
    }

    /// Presents a sheet when a binding to a Boolean value that you provide is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier’s content closure. Default - .constat(.true) so the sheet is always displayed.
    ///   - sheetContent: A closure that returns the content of the sheet.
    @ViewBuilder
    func bottomSheet<SheetContent: View>(
        isPresented: Binding<Bool> = .constant(true),
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> some BottomSheet {
        IsPresentedBottomSheet(
            isPresented: isPresented,
            content: { self },
            sheetContent: sheetContent
        )
    }

}

private struct ExampleView: View {
    // Used by `Map` tab
    @State var selectedDetent = Detent.small

    // Used by `Messages` tab
    @State var isPresented: Bool = true

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
            // Uses `@State var selectedDetent`
            Tab("Map", systemImage: "map") {
                VStack {
                    // When using `selectedDetent`, you can check `.hidden`
                    var isPresented: Bool {
                        selectedDetent != .hidden
                    }

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

            // Uses `@State var isPresented`
            Tab("Messages", systemImage: "message") {
                VStack {
                    Text("isPresented: \(isPresented.description)")
                    Button(isPresented ? "Show `BottomSheet`" : "Hide `BottomSheet`") {
                        isPresented.toggle()
                    }
                }
                .bottomSheet(isPresented: $isPresented) {
                    rainbowList
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

