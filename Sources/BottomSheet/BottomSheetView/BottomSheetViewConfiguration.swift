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
    
    init(sheetColor: Color = .white,
         dragIndicator: DragIndicator = .init()) {
        self.sheetColor = sheetColor
        self.dragIndicator = dragIndicator
    }
}

extension BottomSheetViewConfiguration {
    struct DragIndicator {
        var isPresented: Bool = false
        var color: Color = .gray
    }
}
