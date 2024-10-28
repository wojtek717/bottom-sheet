//
//  BottomSheetViewConfiguration.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

@Observable
class BottomSheetViewConfiguration {
    var sheetColor: Color?
    var dragIndicator: DragIndicator
    var detents: [Detent]
    var cornerRadius: CGFloat
    /// Edges that ignore the safe area
    var ignoredEdges: Edge.Set

    init(
        sheetColor: Color? = nil,
        dragIndicator: DragIndicator = .init(),
        detents: [Detent] = [.large],
        cornerRadius: CGFloat = 20,
        ignoredEdges: Edge.Set = [],
        setInitialDetent: Bool = false
    ) {
        self.sheetColor = sheetColor
        self.dragIndicator = dragIndicator
        self.cornerRadius = cornerRadius
        self.ignoredEdges = ignoredEdges

        var detents = detents

        // Ensure there is always a detent present in `detents`
        if detents.isEmpty {
            assertionFailure("`detents` should always be populated")
            detents.append(.large)
        }
        self.detents = detents
    }
}

extension BottomSheetViewConfiguration {
    struct DragIndicator {
        var isPresented: Bool = false
        var color: Color = .gray
    }
}
