//
//  ScrollViewWrapper.swift
//  BottomSheet
//
//  Created by Sam Doggett on 12/8/24.
//

import SwiftUI

public struct ScrollViewWrapper<Content: View>: UIViewRepresentable {
    @Binding var isDragGestureEnabled: Bool
    @Binding var selectedDetent: Detent
    
    let detents: [Detent]
    let content: Content
    
    public init(
        isDragGestureEnabled: Binding<Bool>,
        selectedDetent: Binding<Detent>,
        detents: [Detent],
        @ViewBuilder content: () -> Content
    ) {
        self._isDragGestureEnabled = isDragGestureEnabled
        self._selectedDetent = selectedDetent

        self.detents = detents
        self.content = content()
    }
    
    public func makeUIView(context: UIViewRepresentableContext<ScrollViewWrapper>) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        
        let controller = UIHostingController(rootView: content)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            controller.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        context.coordinator.hostingController = controller
        
        return scrollView
    }
    
    public func updateUIView(_ uiView: UIScrollView, context: UIViewRepresentableContext<ScrollViewWrapper>) {
        let scrollView = uiView
        
        let isMaxDetent = selectedDetent == detents.max()

        scrollView.isScrollEnabled = isMaxDetent

        if !isMaxDetent {
            scrollView.setContentOffset(.zero, animated: true)
        }

        if let hostingController = context.coordinator.hostingController {
            hostingController.rootView = content
        }
        
        if let hostedView = scrollView.subviews.first {
            hostedView.frame = CGRect(origin: .zero, size: scrollView.contentSize)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator {
            self.isDragGestureEnabled = $0
        }
    }
    
    public class Coordinator: NSObject, UIScrollViewDelegate {
        var hostingController: UIHostingController<Content>?

        let setDragGestureEnabled: (Bool) -> Void

        init(setDragGestureEnabled: @escaping (Bool) -> Void) {
            self.setDragGestureEnabled = setDragGestureEnabled
        }
        
        public func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let isDragGestureEnabled = scrollView.contentOffset.y <= 0

            setDragGestureEnabled(isDragGestureEnabled)

            if isDragGestureEnabled {
                // Cancel existing scroll gesture
                scrollView.panGestureRecognizer.isEnabled = false
                scrollView.panGestureRecognizer.isEnabled = true
            }
        }
    }
}
