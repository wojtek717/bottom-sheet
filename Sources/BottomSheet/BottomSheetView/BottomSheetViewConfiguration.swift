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
    var selectedDetent: Detent
    var detents: [Detent]
    var cornerRadius: CGFloat
    /// Edges that ignore the safe area
    var ignoredEdges: Edge.Set?
    
    init(
        sheetColor: Color? = nil,
        dragIndicator: DragIndicator = .init(),
        detents: [Detent] = [.large],
        cornerRadius: CGFloat = 20,
        ignoredEdges: Edge.Set? = .bottom
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

        guard let smallestDetent = detents.min(by: { $0.fraction < $1.fraction }) else {
            preconditionFailure("`smallestDetent` should never be nil")
        }

        self.selectedDetent = smallestDetent
    }
}

extension BottomSheetViewConfiguration {
    struct DragIndicator {
        var isPresented: Bool = false
        var color: Color = .gray
    }
}
