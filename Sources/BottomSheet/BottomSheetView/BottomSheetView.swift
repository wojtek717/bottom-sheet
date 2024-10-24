//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

struct BottomSheetView<Content:View>: View {
    @State private var sheetHeight: CGFloat = 0.0
    @State private var offset = CGSize.zero
    @State private var isNegativeScrollOffset = false
    
    @ViewBuilder private let content: () -> Content
    private var detents: [Detent] = [.large]
    
    internal var configuration: BottomSheetViewConfiguration
    
    init(detents: [Detent] = [.large], configuration: BottomSheetViewConfiguration, content: @escaping () -> Content) {
        self.content = content
        self.detents = detents
        self.configuration = configuration
    }
    
    private func isMaxDetentReached(_ screenHeight: CGFloat) -> Bool {
        let maxFraction = detents.map(\.fraction).max() ?? 0.0
        
        if isNegativeScrollOffset == true {
            return true
        }
        
        if (screenHeight * maxFraction).rounded() <= sheetHeight.rounded() {
            return false
        } else {
            return true
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            
            VStack {
                Spacer()
                
                ScrollView {
                    content()
                }
                .onScrollGeometryChange(for: Double.self, of: { geometry in
                    return geometry.contentOffset.y
                }, action: { oldValue, newValue in
                    print(newValue)
                    
                    if newValue < 0.0 {
                        sheetHeight = sheetHeight + newValue
                    }
                    
                    isNegativeScrollOffset = newValue < 0.0
                })
                .scrollDisabled(isMaxDetentReached(screenHeight))
                .frame(maxWidth: .infinity)
                .frame(height: sheetHeight)
                .background(configuration.sheetColor)
                .cornerRadius(20)
                .shadow(radius: 10)
                .animation(.easeInOut, value: sheetHeight)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            offset = gesture.translation
                            
                            
                            let newSheetHeight = sheetHeight - offset.height.rounded()
                            
                            if newSheetHeight > (detents.map(\.fraction).max() ?? 0.0) * screenHeight{
                                return
                            }
                            
                            sheetHeight = newSheetHeight
                        }
                        .onEnded({ gesture in
                            let detent = Detent.forValue(sheetHeight / screenHeight, from: detents)
                            sheetHeight = screenHeight * detent.fraction
                        })
                )
            }
            .onAppear {
                sheetHeight = (detents.map(\.fraction).min() ?? 1.0) * screenHeight
            }
        }
    }
}
