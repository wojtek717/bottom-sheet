//
//  BottomSheet.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

public protocol BottomSheet: View {
    associatedtype Content: View
    associatedtype SheetContent: View

    var configuration: BottomSheetViewConfiguration { get set }
}
