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
    ///   - detents: A set of supported detents for the sheet. If you provide more that one detent, people can drag the sheet to resize it.
    func detentsPresentation(detents: [Detent]) -> some BottomSheet {
        configuration.detents = detents
        return self
    }

 }
