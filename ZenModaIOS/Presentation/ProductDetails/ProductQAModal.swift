//
//  ProductQAModal.swift
//  ZenModaIOS
//
//  Created by Shahruh on 21.07.2025.
//

import SwiftUI

struct ProductQAModalWrapper: View {
    @ObservedObject var viewModel: ProductDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("product_qa_title".localizedString())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    viewModel.resetProductQAForm()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 120)
                        
                        if viewModel.productQuestionText.isEmpty {
                            Text("question_placeholder".localizedString())
                                .font(.system(size: 16))
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                        }
                        
                        TextEditor(text: $viewModel.productQuestionText)
                            .frame(height: 100)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.clear)
                            .transparentScrolling()
                            .cornerRadius(8)
                        
                    }
                }
                .padding(.horizontal, 20)
                
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.agreeToQATerms.toggle()
                    }) {
                        Image(systemName: viewModel.agreeToQATerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(viewModel.agreeToQATerms ? .blue : .gray)
                            .font(.system(size: 20))
                    }
                    
                    HStack(spacing: 4) {
                        Text("agree_to".localizedString())
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        
                        Button(action: {
                            
                        }) {
                            Text("terms_and_conditions".localizedString())
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                                .underline()
                        }
                        
                        Text("i_agree".localizedString())
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .background(Color.white)
            
            VStack(spacing: 0) {
                Divider()
                
                Button(action: {
                    viewModel.submitProductQuestion()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        if viewModel.isSubmittingQuestion {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text("send_question".localizedString())
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(canSubmit ? Color.blue : Color.gray)
                    .cornerRadius(12)
                }
                .disabled(!canSubmit || viewModel.isSubmittingQuestion)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.white)
            }
        }
        .background(Color.white)
    }
    
    private var canSubmit: Bool {
        return !viewModel.productQuestionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        viewModel.agreeToQATerms
    }
}


public extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
