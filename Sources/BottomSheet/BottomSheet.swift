//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

/// A protocol that defines the basic structure for bottom sheet implementations.
///
/// Bottom sheets are UI components that slide up from the bottom of the screen and can be
/// configured to stop at various heights (detents).
public protocol BottomSheet: View {
    /// The type of the main content view that appears behind the bottom sheet.
    associatedtype Content: View
    
    /// The type of content that appears within the bottom sheet itself.
    associatedtype SheetContent: View

    /// Configuration options that control the bottom sheet's appearance and behavior.
    var configuration: BottomSheetViewConfiguration { get set }
}
