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
    
    init(sheetColor: Color = .white,
         dragIndicator: DragIndicator = .init(),
         detents: [Detent] = [.large]) {
        self.sheetColor = sheetColor
        self.dragIndicator = dragIndicator
        self.detents = detents
    }
}

extension BottomSheetViewConfiguration {
    struct DragIndicator {
        var isPresented: Bool = false
        var color: Color = .gray
    }
}
