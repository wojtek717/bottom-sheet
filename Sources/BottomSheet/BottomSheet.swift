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
    
    private let detents: [Detent]
    private let view: V
    
    internal var configuration: BottomSheetViewConfiguration = .init()
    
    public init(isPresented: Binding<Bool>, sheetContent: @escaping () -> SheetContent, detents: [Detent], view: V) {
        self._isPresented = isPresented
        self.sheetContent = sheetContent
        self.detents = detents
        self.view = view
    }
    
    public var body: some View {
        ZStack {
            view
            
            if isPresented {
                BottomSheetView(detents: detents, configuration: configuration, content: sheetContent)
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

public extension View {
    func bottomSheet<SheetContent:View>(
        isPresented: Binding<Bool>,
        detents: [Detent] = [.large],
        sheetContent: @escaping ()
        -> SheetContent) -> BottomSheet<SheetContent, Self> {
            
            BottomSheet(isPresented: isPresented, sheetContent: sheetContent, detents: detents, view: self)
        }
}

private struct ExampleView: View {
    var body: some View {
        Text("Hello World!")
            .bottomSheet(isPresented: .constant(true), detents: [.small, .medium, .large]) {
                Text("Bottom Sheet")
                    .padding(20)
            }
            .sheetColor(.blue)
            .dragIndicatorPresentation(isVisible: true)
    }
}

#Preview {
    ExampleView()
}

