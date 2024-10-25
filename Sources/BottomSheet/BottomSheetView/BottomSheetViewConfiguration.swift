//
//  BottomSheetViewConfiguration.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

class BottomSheetViewConfiguration {
    var sheetColor: Color
    var dragIndicator: DragIndicator
    var detents: [Detent]
    var ignoredEdges: Edge.Set?
    
    init(sheetColor: Color = .white,
         dragIndicator: DragIndicator = .init(),
         detents: [Detent] = [.large],
         ignoredEdges: Edge.Set? = .bottom) {
        self.sheetColor = sheetColor
        self.dragIndicator = dragIndicator
        self.detents = detents
        self.ignoredEdges = ignoredEdges
    }
}

extension BottomSheetViewConfiguration {
    struct DragIndicator {
        var isPresented: Bool = false
        var color: Color = .gray
    }
}
