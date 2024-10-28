//
//  BottomSheet+ignoresSafeAreaEdgesPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {    
    func ignoresSafeAreaEdgesPresentation(_ edges: Edge.Set?) -> BottomSheet {
        self.configuration.ignoredEdges = edges ?? []
        return self
    }
}
