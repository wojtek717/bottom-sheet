//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

public struct BottomSheet<SheetContent:View, V: View>: View {
    @Binding private var isPresented: Bool
    @ViewBuilder private let sheetContent: () -> SheetContent
    
    private let view: V
    
    internal var configuration: BottomSheetViewConfiguration = .init()
    var edges: Edge.Set?
    
    public init(isPresented: Binding<Bool>, sheetContent: @escaping () -> SheetContent, view: V) {
        self._isPresented = isPresented
        self.sheetContent = sheetContent
        self.view = view
    }
    
    public var body: some View {
        ZStack {
            view
            
            if isPresented {
                BottomSheetView(configuration: configuration, content: sheetContent)
                    .ignoresSafeAreaEdges(configuration.ignoredEdges)
            }
        }
    }
}

public extension View {
    func bottomSheet<SheetContent:View>(
        isPresented: Binding<Bool>,
        sheetContent: @escaping ()
        -> SheetContent) -> BottomSheet<SheetContent, Self> {
            
            BottomSheet(isPresented: isPresented, sheetContent: sheetContent, view: self)
        }
}

private struct ExampleView: View {
    var body: some View {
        Text("Hello World!")
            .bottomSheet(isPresented: .constant(true)) {
                ScrollView {
                    Text("Bottom Sheet")
                        .padding(20)
                }
            }
            .sheetColor(.blue)
            .dragIndicatorPresentation(isVisible: true)
            .detentsPresentation(detents: [.small, .medium, .large])
    }
}

#Preview {
    ExampleView()
}

