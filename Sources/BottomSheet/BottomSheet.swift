//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

public struct BottomSheet<Content: View, SheetContent: View>: View {
    @State var configuration = BottomSheetViewConfiguration()

    @Binding private var isPresented: Bool
    private let content: Content
    private let sheetContent: SheetContent

    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content,
        @ViewBuilder sheetContent: () -> SheetContent
    ) {
        self._isPresented = isPresented
        self.content = content()
        self.sheetContent = sheetContent()
    }
    
    public var body: some View {
        ZStack {
            content
            
            if isPresented {
                BottomSheetView(
                    configuration: $configuration,
                    content: sheetContent
                )
            }
        }
    }
}

public extension View {
    /// Presents a sheet when a binding to a Boolean value that you provide is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier’s content closure.
    ///   - sheetContent: A closure that returns the content of the sheet.
    func bottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> BottomSheet<Self, SheetContent> {
        BottomSheet(
            isPresented: isPresented,
            content: { self },
            sheetContent: sheetContent
        )
    }
    
    /// Presents a sheet.
    /// - Parameter sheetContent: A closure that returns the content of the sheet.
    func bottomSheet<SheetContent: View>(
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> BottomSheet<Self, SheetContent> {
        BottomSheet(
            isPresented: .constant(true),
            content: { self },
            sheetContent: sheetContent
        )
    }
}

private struct ExampleView: View {
    let colors: [Color] = [.red, .orange, .yellow, .green, .blue, .indigo, .purple]
    @State private var isShowingSheet = false

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
                Text("Map")
                    .bottomSheet {
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

