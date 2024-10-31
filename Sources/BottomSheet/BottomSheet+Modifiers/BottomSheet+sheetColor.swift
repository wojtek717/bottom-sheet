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

}
