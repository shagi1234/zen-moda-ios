//
//  ToastModifier.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//


import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let toastType: ToastType
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    ToastView(message: message,
                              toastType: toastType)
                    .padding(.bottom, 20)
                    .transition(.slide)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.isPresented = false
                            }
                        }
                    }
                }
                .animation(.easeInOut, value: isPresented)
            }
        }
    }
}

struct ToastView: View {
    let message: String
    let toastType: ToastType
    
    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(toastType == .success ? Color.green : toastType == .info ? Color.blue : Color.red)
            .cornerRadius(10)
            .shadow(radius: 10)
            .opacity(0.8)
    }
}

