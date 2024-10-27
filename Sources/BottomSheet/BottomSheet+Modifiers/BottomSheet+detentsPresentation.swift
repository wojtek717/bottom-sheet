//
//  BottomSheet+detentsPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {
    func detentsPresentation(initialDetent: Detent? = nil, detents: [Detent]) -> BottomSheet {
        configuration.detents = detents
        if let initialDetent = initialDetent ?? detents.smallest, !configuration.setInitialDetent {
            configuration.selectedDetent = initialDetent
        }
        return self
    }
 }
