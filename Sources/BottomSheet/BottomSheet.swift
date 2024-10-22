import SwiftUI

public struct CustomSheetView<Content:View>: View {
    @State private var sheetHeight: CGFloat = 0.0
    @State private var offset = CGSize.zero
    @State private var canScroll = false
    
    private var detents: [Detent] = [.large]
    
    @ViewBuilder
    private let content: () -> Content
    
    public init(detents: [Detent] = [.large], content: @escaping () -> Content) {
        self.content = content
        self.detents = detents
    }
    
    private func isMaxDetentReached(_ screenHeight: CGFloat) -> Bool {
        let maxFraction = detents.map(\.fraction).max() ?? 0.0
        
        if canScroll == true {
            return true
        }
        
        if (screenHeight * maxFraction).rounded() <= sheetHeight.rounded() {
            return false
        } else {
            return true
        }
    }
    
    public var body: some View {
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
                    
                    
                    canScroll = newValue < 0.0
                })
                .scrollDisabled(isMaxDetentReached(screenHeight))
                .background(Color.red)
                .frame(maxWidth: .infinity)
                .frame(height: sheetHeight)
                .background(Color.white)
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

struct BottomSheetModifier<SheetContent:View>: ViewModifier {
    @Binding private var isPresented: Bool
    
    @ViewBuilder
    private let sheetContent: () -> SheetContent
    
    private let detents: [Detent]
    
    init(isPresented: Binding<Bool>, sheetContent: @escaping () -> SheetContent, detents: [Detent]) {
        self._isPresented = isPresented
        self.sheetContent = sheetContent
        self.detents = detents
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                CustomSheetView(detents: detents, content: sheetContent)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

public extension View {
    func bottomSheet<SheetContent:View>(
        isPresented: Binding<Bool>,
        detents: [Detent] = [.large],
        sheetContent: @escaping ()
        -> SheetContent) -> some View {
        
        modifier(BottomSheetModifier(
            isPresented: isPresented,
            sheetContent: sheetContent,
            detents: detents))
    }
}
