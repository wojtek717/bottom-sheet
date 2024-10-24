//
//  BottomSheet+detentsPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {
    func detentsPresentation(detents: [Detent]) -> BottomSheet {
        self.configuration.detents = detents
        return self
    }
 }
