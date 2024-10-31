//
//  View+Extensions.swift
//  BottomSheet
//
//  Created by Sam Doggett on 10/28/24.
//

import SwiftUI

public extension View {

    /// Presents a sheet when a binding to a Boolean value that you provide is true.
    /// - Parameters:
    ///   - selectedDetent: A binding to a `Detent` value that determines how to present the sheet that you create in the modifier’s content closure.
    ///   - sheetContent: A closure that returns the content of the sheet.
    @ViewBuilder
    func bottomSheet<SheetContent: View>(
        selectedDetent: Binding<Detent>,
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> some BottomSheet {
        SelectedDetentBottomSheet(
            selectedDetent: selectedDetent,
            content: { self },
            sheetContent: sheetContent
        )
    }

    /// Presents a sheet when a binding to a Boolean value that you provide is true.
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the sheet that you create in the modifier’s content closure. Default - .constat(.true) so the sheet is always displayed.
    ///   - sheetContent: A closure that returns the content of the sheet.
    @ViewBuilder
    func bottomSheet<SheetContent: View>(
        isPresented: Binding<Bool> = .constant(true),
        @ViewBuilder sheetContent: () -> SheetContent
    ) -> some BottomSheet {
        IsPresentedBottomSheet(
            isPresented: isPresented,
            content: { self },
            sheetContent: sheetContent
        )
    }

}
