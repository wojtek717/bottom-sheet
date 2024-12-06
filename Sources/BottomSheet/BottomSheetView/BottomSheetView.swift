//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @State private var sheetHeight: CGFloat = 0.0
    @State private var scrollDisabled: Bool
    @State private var scrollPosition = ScrollPosition()

    @Binding private var configuration: BottomSheetViewConfiguration
    @Binding private var selectedDetent: Detent

    var detents: [Detent] {
        configuration.detents
    }

    /// Height of the container of this sheet
    private let parentHeight: CGFloat

    /// Content to be displayed behind the sheet
    private let content: Content

    init(
        configuration: Binding<BottomSheetViewConfiguration>,
        selectedDetent: Binding<Detent>,
        parentHeight: CGFloat,
        content: Content
    ) {
        self._configuration = configuration
        self._selectedDetent = selectedDetent
        self.parentHeight = parentHeight
        self.content = content
        self.scrollDisabled = selectedDetent.wrappedValue != configuration.detents.wrappedValue.max()
    }
    
    var body: some View {
        content
            .scrollPosition($scrollPosition)
            .frame(height: sheetHeight)
            .ignoresSafeArea(edges: configuration.ignoredEdges)
            .overlay(alignment: .top, content: {
                if configuration.dragIndicator.isPresented {
                    Capsule()
                        .frame(width: 50, height: 5)
                        .foregroundStyle(configuration.dragIndicator.color)
                        .padding(.top, 5)
                }
            })
            .background(configuration.sheetColor)
            .clipShape(
                .rect(
                    topLeadingRadius: configuration.cornerRadius,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: configuration.cornerRadius
                )
            )
            .shadow(radius: 10)
            .animation(.spring, value: sheetHeight)
            // Ensures `DragGesture` works everywhere on sheet
            .contentShape(.rect)
            .scrollDisabled(scrollDisabled && selectedDetent != detents.max())
            // It is important to update `BottomSheetView` as infrequently as possible
            // in `action`
            .onScrollGeometryChange(for: Bool.self) { geometry in
                geometry.contentOffset.y <= 0
            } action: { _, newValue in
                scrollDisabled = newValue
            }
            // Always be listening to `DragGesture` to ensure for seemless
            // sheet detent changes
            .simultaneousGesture(
                DragGesture()
                    .onChanged({ value in
                        dragGestureOnChanged(value)
                    })
                    .onEnded({ value in
                        dragGestureOnEnded(value)
                    })
            )
            .onChange(of: parentHeight, { _, parentHeight in
                sheetHeight = selectedDetent.fraction * parentHeight
            })
            .onAppear {
                sheetHeight = selectedDetent.fraction * parentHeight
            }
    }
}

extension BottomSheetView {

    func dragGestureOnChanged(_ gesture: DragGesture.Value) {
        guard scrollDisabled else { return }

        let desiredHeight = sheetHeight - gesture.translation.height

        let minHeight = (detents.map(\.fraction).min() ?? 1.0) * parentHeight
        let maxHeight = (detents.map(\.fraction).max() ?? 0.0) * parentHeight

        // Clamp desired height within bounds
        let clampedDesiredHeight = max(minHeight, min(desiredHeight, maxHeight))

        self.sheetHeight = clampedDesiredHeight
    }

    func dragGestureOnEnded(_ gesture: DragGesture.Value) {
        // Calculate the current fraction of the screen height
        let currentFraction = sheetHeight / parentHeight

        // Find the closest detent based on the current fraction
        self.selectedDetent = detents.min(by: {
            abs($0.fraction - currentFraction) < abs($1.fraction - currentFraction)
        }) ?? .small

        // Calculate the desired height for the closest detent
        let desiredHeight = parentHeight * selectedDetent.fraction

        self.sheetHeight = desiredHeight
    }

}
