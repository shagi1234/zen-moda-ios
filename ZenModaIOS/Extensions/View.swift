//
//  ScrollFriendlyButtonModifier.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//


import SwiftUI
import Combine

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    var safeArea: UIEdgeInsets {
        if #available(iOS 15.0, *) {
            if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
                return safeArea
            }
        } else {
            if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                return window.safeAreaInsets
            }
        }
        return .zero
    }
    
    var tabBarHeight: CGFloat {
        return 49 + safeArea.bottom
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    @ViewBuilder func onValueChanged<T: Equatable>(of value: T, perform onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { (value) in
                onChange(value)
            }
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String,toastType: ToastType) -> some View {
        self.modifier(ToastModifier(isPresented: isPresented, message: message,toastType: toastType))
    }
}

extension View {
    func customBlur(radius: CGFloat) -> some View {
        modifier(CustomBlurEffect(radius: radius))
    }
}


struct ScrollFriendlyButtonModifier: ViewModifier {
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1)
            .opacity(isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { _ in
                        if !isPressed {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                isPressed = true
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isPressed = false
                        }
                        
                        // Only allow button press if drag distance is very small
                        let distance = sqrt(pow(value.translation.width, 2) + pow(value.translation.height, 2))
                        if distance > 10 {
                            // Prevent button action on scroll by consuming the gesture
                        }
                    }
            )
    }
}

struct ScrollFriendlyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
            .allowsHitTesting(true)
            .contentShape(Rectangle())
            .onTapGesture(count: 2) { }
    }
}

extension Button {
    func pressAnimation() -> some View {
        self
            .buttonStyle(PlainButtonStyle())
            .modifier(ScrollFriendlyButtonModifier())
    }
}

struct ScrollFriendlyPressModifier: ViewModifier {
    let action: () -> Void
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.97 : 1)
            .opacity(isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isPressed = false
                    }
                    action()
                }
            }
    }
}

extension View {
    func pressWithAnimation(_ action: @escaping () -> Void) -> some View {
        self.modifier(ScrollFriendlyPressModifier(action: action))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
