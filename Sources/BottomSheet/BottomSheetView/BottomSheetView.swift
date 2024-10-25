//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

struct BottomSheetView<Content:View>: View {
    @State private var sheetHeight: CGFloat = 0.0
    @State private var isNegativeScrollOffset = false
    @ViewBuilder private let content: () -> Content
    
    internal var configuration: BottomSheetViewConfiguration
    
    init(configuration: BottomSheetViewConfiguration, content: @escaping () -> Content) {
        self.content = content
        self.configuration = configuration
    }
    
    private var dragIndicator: some View {
        VStack {
            Capsule()
                .frame(width: 50, height: 5)
                .foregroundStyle(configuration.dragIndicator.color)
                .padding(.top, 5)
            
            Spacer()
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            let screenHeight = geometry.size.height
            
            VStack {
                Spacer()
                
                ZStack {
                    content()
                    // Describe scroll behaviour if content is wrapped with ScrollView
                        .scrollDisabled(isMaxDetentReached(screenHeight))
                        .onScrollGeometryChange(for: Double.self, of: { geometry in
                            return geometry.contentOffset.y
                        }, action: { oldValue, newValue in
                            print(newValue)
                            
                            if newValue < 0.0 {
                                sheetHeight = sheetHeight + newValue
                            }
                            
                            isNegativeScrollOffset = newValue < 0.0
                        })
                    
                    if configuration.dragIndicator.isPresented {
                        dragIndicator
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: sheetHeight)
                .background(configuration.sheetColor)
                .clipShape(
                    .rect(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20
                    )
                )
                .shadow(radius: 10)
                .animation(.easeInOut, value: sheetHeight)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragGestureOnChanged(gesture, screenHeight: screenHeight)
                        }
                        .onEnded({ gesture in
                            dragGestureOnEnded(gesture, screenHeight: screenHeight)
                        })
                )
            }
            .onAppear {
                onAppear(screenHeight: screenHeight)
            }
        }
    }
}

private extension BottomSheetView {
    func isMaxDetentReached(_ screenHeight: CGFloat) -> Bool {
        let maxFraction = configuration.detents.map(\.fraction).max() ?? 0.0
        
        if isNegativeScrollOffset == true {
            return true
        }
        
        if (screenHeight * maxFraction).rounded() <= sheetHeight.rounded() {
            return false
        } else {
            return true
        }
    }
    
    func dragGestureOnChanged(_ gesture: DragGesture.Value, screenHeight: CGFloat) {
        let offset = gesture.translation
        let newSheetHeight = sheetHeight - offset.height.rounded()
        
        if newSheetHeight > (configuration.detents.map(\.fraction).max() ?? 0.0) * screenHeight {
            return
        }
        
        sheetHeight = newSheetHeight
    }
    
    func dragGestureOnEnded(_ gesture: DragGesture.Value, screenHeight: CGFloat) {
        let detent = Detent.forValue(sheetHeight / screenHeight, from: configuration.detents)
        sheetHeight = screenHeight * detent.fraction
    }
    
    func onAppear(screenHeight: CGFloat) {
        sheetHeight = (configuration.detents.map(\.fraction).min() ?? 1.0) * screenHeight
    }
}
