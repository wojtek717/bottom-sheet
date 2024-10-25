//
//  BottomSheet+ignoresSafeAreaEdgesPresentation.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 24/10/2024.
//

import SwiftUI

public extension BottomSheet {    
    func ignoresSafeAreaEdgesPresentation(_ edges: Edge.Set?) -> BottomSheet {
        self.configuration.ignoredEdges = edges
        return self
    }
}

extension BottomSheetView {
    func ignoresSafeAreaEdges(_ edges: Edge.Set?) -> some View{
        self.modifier(IgnoresSafeAreaModifier(edges: edges))
    }
}

struct IgnoresSafeAreaModifier: ViewModifier {
    var edges: Edge.Set?
    
    func body(content: Content) -> some View {
        if let edges {
            content
                .ignoresSafeArea(edges: edges)
        } else {
            content
        }
    }
}
