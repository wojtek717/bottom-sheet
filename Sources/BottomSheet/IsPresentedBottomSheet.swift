//
//  IsPresentedBottomSheet.swift
//  BottomSheet
//
//  Created by Sam Doggett on 10/28/24.
//

import SwiftUI

/// A bottom sheet implementation that can be shown or hidden using a boolean binding.
///
/// This view provides a simple way to present a bottom sheet using SwiftUI's standard
/// presentation pattern with a binding to a boolean value.
///
/// Example usage:
/// ```swift
/// @State private var isPresented = false
///
/// var body: some View {
///     ContentView()
///         .bottomSheet(isPresented: $isPresented) {
///             SheetContent()
///         }
/// }
/// ```
struct IsPresentedBottomSheet<Content: View, SheetContent: View>: BottomSheet {
    /// The configuration options for the bottom sheet.
    @State var configuration: BottomSheetViewConfiguration
    
    /// The currently selected detent (height stop) of the bottom sheet.
    @State var selectedDetent: Detent = .small

    /// Binding that controls whether the bottom sheet is presented.
    @Binding var isPresented: Bool

    /// The initial detent to use when the sheet is presented.
    private let initialDetent: Detent
    
    /// The main content view that appears behind the bottom sheet.
    private let content: Content
    
    /// The content view that appears within the bottom sheet.
    private let sheetContent: SheetContent

    /// Creates a new bottom sheet with presentation controlled by a boolean binding.
    /// - Parameters:
    ///   - configuration: Configuration options for the bottom sheet's appearance and behavior.
    ///   - isPresented: A binding to a Boolean value that determines whether to show the sheet.
    ///   - initialDetent: The initial detent (height) to use when the sheet is presented.
    ///   - content: A view builder that creates the main content.
    ///   - sheetContent: A view builder that creates the content shown in the bottom sheet.
    public init(
        configuration: BottomSheetViewConfiguration = .init(),
        isPresented: Binding<Bool>,
        initialDetent: Detent = .small,
        @ViewBuilder content: () -> Content,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
        self.configuration = configuration
        self._isPresented = isPresented
        self.initialDetent = initialDetent
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
            selectedDetent = isPresented ? initialDetent : .hidden
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

