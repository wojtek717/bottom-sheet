//
//  BottomSheet+ignoresSafeAreaEdgesPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {    
    /// Expands the safe area of a view.
    /// - Parameter edges: The set of edges to expand. If nil or empty set in passed no edges are expanded.
    func ignoresSafeAreaEdgesPresentation(_ edges: Edge.Set?) -> BottomSheet {
        self.configuration.ignoredEdges = edges ?? []
        return self
    }
}
