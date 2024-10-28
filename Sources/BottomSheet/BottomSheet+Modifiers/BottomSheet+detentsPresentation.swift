//
//  BottomSheet+detentsPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {
    
    /// Sets the available detents for the sheet.
    /// - Parameters:
    ///   - initialDetent: Initial size of sheet.
    ///   - detents: A set of supported detents for the sheet. If you provide more that one detent, people can drag the sheet to resize it.
    func detentsPresentation(initialDetent: Detent? = nil, detents: [Detent]) -> BottomSheet {
        configuration.detents = detents
        if let initialDetent = initialDetent ?? detents.smallest, !configuration.setInitialDetent {
            // Ensure this conditional is executed once
            configuration.setInitialDetent = true
            configuration.selectedDetent = initialDetent
        }
        return self
    }
 }
