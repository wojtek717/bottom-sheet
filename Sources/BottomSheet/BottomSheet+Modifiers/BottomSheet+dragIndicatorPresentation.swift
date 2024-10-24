//
//  BottomSheet+dragIndicatorPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {
    func dragIndicatorPresentation(isVisible: Bool, color: Color = .gray) -> BottomSheet {
        self.configuration.dragIndicator = .init(isPresented: isVisible, color: color)
        return self
    }
}
