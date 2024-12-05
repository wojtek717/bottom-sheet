//
//  BottomSheet+sheetColor.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {

    /// Sets the backgroud color of the sheet.
    /// - Parameter color: Color to set.
    func sheetColor(_ color: Color) -> some BottomSheet {
        self.configuration.sheetColor = color
        return self
    }

    /// Sets the available detents for the sheet.
    /// - Parameters:
    ///   - detents: A set of supported detents for the sheet. If you provide more that one detent, people can drag the sheet to resize it.
    func detentsPresentation(detents: [Detent]) -> some BottomSheet {
        if detents.isEmpty {
            configuration.detents = [.hidden]
        } else {
            configuration.detents = detents
        }
        return self
    }

    /// Expands the safe area of a view.
    /// - Parameter edges: The set of edges to expand. If nil or empty set in passed no edges are expanded.
    func ignoresSafeAreaEdgesPresentation(_ edges: Edge.Set?) -> some BottomSheet {
        self.configuration.ignoredEdges = edges ?? []
        return self
    }

    /// Sets the visibility of the drag indicator on top of a sheet.
    /// - Parameters:
    ///   - isVisible: Sets the visibility of the drag indicator.
    ///   - color: Color of the drag indicator
    func dragIndicatorPresentation(isVisible: Bool, color: Color = .gray) -> some BottomSheet {
        self.configuration.dragIndicator = .init(isPresented: isVisible, color: color)
        return self
    }

}
