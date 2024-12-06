//
//  SelectedDetentBottomSheet.swift
//  BottomSheet
//
//  Created by Sam Doggett on 10/28/24.
//

import SwiftUI

/// A bottom sheet implementation that provides direct control over its presentation state
/// through a detent binding.
///
/// This view allows for more granular control over the bottom sheet's height by directly
/// binding to a `Detent` value instead of a simple boolean. This enables smooth transitions
/// between different height stops and programmatic control of the sheet's position.
///
/// Example usage:
/// ```swift
/// @State private var selectedDetent: Detent = .small
///
/// var body: some View {
///     ContentView()
///         .bottomSheet(selectedDetent: $selectedDetent) {
///             SheetContent()
///         }
/// }
/// ```
struct SelectedDetentBottomSheet<Content: View, SheetContent: View>: BottomSheet {
    /// The configuration options for the bottom sheet.
    @State var configuration: BottomSheetViewConfiguration

    /// Binding to the currently selected detent, controlling the sheet's height.
    @Binding var selectedDetent: Detent

    @State private var contentSize: CGSize = .zero

    /// The main content view that appears behind the bottom sheet.
    private let content: Content
    
    /// The content view that appears within the bottom sheet.
    private let sheetContent: SheetContent

    /// Creates a new bottom sheet with presentation controlled by a detent binding.
    /// - Parameters:
    ///   - configuration: Configuration options for the bottom sheet's appearance and behavior.
    ///   - selectedDetent: A binding to a Detent value that controls the sheet's height.
    ///   - content: A view builder that creates the main content.
    ///   - sheetContent: A view builder that creates the content shown in the bottom sheet.
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
        content
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            )
            .onGeometryChange(for: CGSize.self, of: {
                $0.size
            }, action: { newValue in
                contentSize = newValue
            })
            .overlay(alignment: .bottom) {
                if selectedDetent != .hidden {
                    BottomSheetView(
                        configuration: $configuration,
                        selectedDetent: $selectedDetent,
                        parentHeight: contentSize.height,
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
                NavigationStack {
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
                    .navigationTitle("Map")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackgroundVisibility(.visible, for: .navigationBar)
                    .bottomSheet(selectedDetent: $selectedDetent) {
                        RainbowList()
                    }
                    .dragIndicatorPresentation(isVisible: true)
                    // We can prevent the user from swiping to dismiss by excluding `hidden` from
                    // this list, while still supporting hiding it programmatically. Alternatively,
                    // add `.hidden` to this list to allow users to swipe to dismiss.
                    .detentsPresentation(detents: [.small, .medium, .large])
                }
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
