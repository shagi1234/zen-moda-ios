//
//  OtpFormFieldView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.06.2025.
//
import SwiftUI

import SwiftUI

struct OtpFormFieldView: View {
    @ObservedObject var viewModel: AuthViewModel // Changed from @StateObject to @ObservedObject
    
    @State var isFocused = false
    @AppStorage("token") var token = ""
    
    let textBoxWidth = UIScreen.main.bounds.width / 8
    let textBoxHeight = UIScreen.main.bounds.width / 8
    let spaceBetweenBoxes: CGFloat = 10
    let paddingOfBox: CGFloat = 1
    var textFieldOriginalWidth: CGFloat {
        (textBoxWidth*6)+(spaceBetweenBoxes*3)+((paddingOfBox*2)*3)
    }
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                HStack (spacing: spaceBetweenBoxes){
                    
                    otpText(text: viewModel.otp1, position: 0)
                    otpText(text: viewModel.otp2, position: 1)
                    otpText(text: viewModel.otp3, position: 2)
                    otpText(text: viewModel.otp4, position: 3)
                    otpText(text: viewModel.otp5, position: 4)
                }
                
                
                TextField("", text: $viewModel.otpField)
                    .frame(width: isFocused ? 0 : textFieldOriginalWidth, height: textBoxHeight)
                    .disabled(viewModel.isTextFieldDisabled)
                    .textContentType(.oneTimeCode)
                    .foregroundColor(.clear)
                    .accentColor(.clear)
                    .background(Color.clear)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.otpField) { newValue in
                        if newValue.count > 4 {
                            hideKeyboard()
                        }
                    }
                    .accessibilityIdentifier("otp_input_field")
                
                
            }
            
            // Show error if exists
            if viewModel.showError, let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
        }
    }
    
    private func otpText(text: String, position: Int) -> some View {
        
        return Text(text)
            .font(.title)
            .foregroundColor(.primary)
            .frame(width: textBoxWidth, height: textBoxHeight)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .background(ZStack{
                if position > viewModel.otpField.count {
                    Rectangle()
                        .foregroundColor(.bgBase)
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    
                } else if(position == viewModel.otpField.count){
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.showError ? Color.red : Color.accentColor, lineWidth: 0.50)
                    
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(viewModel.showError ? Color.red : Color.accentColor, lineWidth: 0.50)
                }
            })
            .padding(paddingOfBox)
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
