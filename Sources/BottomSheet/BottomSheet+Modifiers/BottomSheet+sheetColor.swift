//
//  BottomSheet+sheetColor.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {
    func sheetColor(_ color: Color) -> BottomSheet {
        self.configuration.sheetColor = color
        return self
    }
}
