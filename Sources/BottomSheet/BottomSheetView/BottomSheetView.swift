//
//  BottomSheetView.swift
//  BottomSheet
//
//  Created by Wojciech Konury on 23/10/2024.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @State private var sheetHeight: CGFloat = 0.0
    @State private var isNegativeScrollOffset = false

    @Binding private var configuration: BottomSheetViewConfiguration

    @Binding private var selectedDetent: Detent

    private let content: Content

    /// Adjust this value to change the smoothing factor for on change drag gesture
    private let smoothingFactor: CGFloat = 0.1

    init(
        configuration: Binding<BottomSheetViewConfiguration>,
        selectedDetent: Binding<Detent>,
        content: Content
    ) {
        self._configuration = configuration
        self._selectedDetent = selectedDetent
        self.content = content
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
                
                content
                // Disable scroll behavior if content is wrapped with ScrollView
                    .scrollDisabled(isMaxDetentReached(screenHeight))
                    .onScrollGeometryChange(for: Double.self) { geometry in
                        return geometry.contentOffset.y
                    } action: { oldValue, newValue in
                        if newValue < 0.0 {
                            sheetHeight = max(
                                minHeight(for: screenHeight),
                                sheetHeight + newValue
                            )
                        }
                        
                        isNegativeScrollOffset = newValue < 0.0
                    }
                    .overlay(content: {
                        if configuration.dragIndicator.isPresented {
                            dragIndicator
                        }
                    })
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: sheetHeight)
                    .background(configuration.sheetColor)
                    .clipShape(
                        .rect(
                            topLeadingRadius: configuration.cornerRadius,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: configuration.cornerRadius
                        )
                    )
                    .shadow(radius: 10)
                    .animation(.easeInOut, value: sheetHeight)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                dragGestureOnChanged(gesture, screenHeight: screenHeight)
                            })
                            .onEnded({ gesture in
                                dragGestureOnEnded(gesture, screenHeight: screenHeight)
                            })
                    )
            }
            .onAppear {
                sheetHeight = selectedDetent.fraction * screenHeight
            }
        }.ignoresSafeArea(edges: configuration.ignoredEdges)
    }
}

extension BottomSheetView {

    var maxFraction: CGFloat {
        configuration.detents.map(\.fraction).max() ?? 0.0
    }

    var minFraction: CGFloat {
        configuration.detents.map(\.fraction).min() ?? 1.0
    }

    func isMaxDetentReached(_ screenHeight: CGFloat) -> Bool {
        if isNegativeScrollOffset == true {
            return true
        }

        return (screenHeight * maxFraction).rounded() > sheetHeight.rounded()
    }
    
    func dragGestureOnChanged(_ gesture: DragGesture.Value, screenHeight: CGFloat) {
        let desiredHeight = sheetHeight - gesture.translation.height

        guard desiredHeight != sheetHeight else { return }

        let minHeight = minHeight(for: screenHeight)
        let maxHeight = maxFraction * screenHeight

        // Clamp desired height within bounds
        let clampedDesiredHeight = max(minHeight, min(desiredHeight, maxHeight))
        
        // Smooth the transition between the current height and the target
        sheetHeight = (sheetHeight * (1 - smoothingFactor)) + (clampedDesiredHeight * smoothingFactor)
    }
    
    func dragGestureOnEnded(_ gesture: DragGesture.Value, screenHeight: CGFloat) {
        let selectedDetent = Detent.forValue(
            sheetHeight / screenHeight,
            from: configuration.detents
        )

        let desiredHeight = screenHeight * selectedDetent.fraction

        if desiredHeight < minHeight(for: screenHeight) {
            return
        }

        self.selectedDetent = selectedDetent
        self.sheetHeight = desiredHeight
    }

    func minHeight(for screenHeight: CGFloat) -> CGFloat {
        minFraction * screenHeight
    }
}
