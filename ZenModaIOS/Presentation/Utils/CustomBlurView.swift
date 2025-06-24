//
//  CustomBlurView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//


import SwiftUI
import UIKit

struct CustomBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    let intensity: CGFloat // Value between 0 and 1
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: nil)
        let blurEffect = UIBlurEffect(style: style)
        view.effect = blurEffect
        
        // Add a secondary view to control intensity
        let backdropView = UIView(frame: .zero)
        backdropView.backgroundColor = .clear
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        view.contentView.addSubview(backdropView)
        
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.contentView.topAnchor),
            backdropView.leadingAnchor.constraint(equalTo: view.contentView.leadingAnchor),
            backdropView.heightAnchor.constraint(equalTo: view.contentView.heightAnchor),
            backdropView.widthAnchor.constraint(equalTo: view.contentView.widthAnchor)
        ])
        
        view.alpha = intensity
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.alpha = intensity
    }
}
struct CustomBlurEffect: ViewModifier {
    let radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .blur(radius: radius)
            .overlay(Color.black.opacity(0.5))
    }
}
