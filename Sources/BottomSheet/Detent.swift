//
//  Detent.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import Foundation

public enum Detent: Equatable, Comparable {
    case large
    case medium
    case small
    case hidden
    case fraction(CGFloat)
    
    var fraction: CGFloat {
        switch self {
        case .large:
            return 1
        case .medium:
            return 0.50
        case .small:
            return 0.20
        case .hidden:
            return 0.0
        case .fraction(let value):
            return value
        }
    }
    
    public static func <(lhs: Detent, rhs: Detent) -> Bool {
        return lhs.fraction < rhs.fraction
    }
}
