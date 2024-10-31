//
//  BottomSheet+dragIndicatorPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {

    /// Sets the visibility of the drag indicator on top of a sheet.
    /// - Parameters:
    ///   - isVisible: Sets the visibility of the drag indicator.
    ///   - color: Color of the drag indicator
    func dragIndicatorPresentation(isVisible: Bool, color: Color = .gray) -> some BottomSheet {
        self.configuration.dragIndicator = .init(isPresented: isVisible, color: color)
        return self
    }

 }
