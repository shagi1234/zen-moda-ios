//
//  ProductQAView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 14.07.2025.
//

import SwiftUI

struct ProductQAView: View {
    let productId: String
    @StateObject var viewModel = ProductDetailViewModel()
    @State private var searchText = ""
    
    var filteredQuestions: [ProductQuestionResponse] {
        if searchText.isEmpty {
            return viewModel.productQuestions
        } else {
            return viewModel.productQuestions.filter { question in
                question.question.localizedCaseInsensitiveContains(searchText) ||
                question.answer.localizedCaseInsensitiveContains(searchText) ||
                question.username.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("search_from_zen_moda".localized, text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            if viewModel.productQuestions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    
                    Text("no_questions_yet".localized)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("be_first_to_ask".localized)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredQuestions, id: \.id) { qaItem in
                            QuestionCard(qaItem: qaItem)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.showProductQAModal = true
            }) {
                Text("ask_question".localized)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 34)
        }
        .onAppear {
            viewModel.loadProductQuestions(productId)
        }
        .sheet(isPresented: $viewModel.showProductQAModal) {
            ProductQAModalWrapper(viewModel: viewModel)
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarTitle("store_qa".localized, displayMode: .inline)
    }
}

struct QuestionCard: View {
    let qaItem: ProductQuestionResponse
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Adjust based on your API date format
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            displayFormatter.locale = Locale.current
            return displayFormatter.string(from: date)
        }
        
        return dateString // Fallback to original string if parsing fails
    }
    
    private func maskUsername(_ username: String) -> String {
        guard username.count > 2 else { return username }
        
        let components = username.components(separatedBy: " ")
        if components.count >= 2 {
            let firstName = components[0]
            let lastName = components[1]
            
            let maskedFirst = firstName.count > 1 ?
            String(firstName.prefix(1)) + String(repeating: "*", count: firstName.count - 1) : firstName
            let maskedLast = lastName.count > 1 ?
            String(lastName.prefix(1)) + String(repeating: "*", count: lastName.count - 1) : lastName
            
            return "\(maskedFirst) \(maskedLast)"
        } else {
            return String(username.prefix(1)) + String(repeating: "*", count: username.count - 1)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(qaItem.question)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("\(maskUsername(qaItem.username)) • \(formatDate(qaItem.createdAt))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: qaItem.store.photo ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.secondary)
                }
                .frame(width: 24, height: 24)
                .clipShape(Circle())
                
                Text(qaItem.store.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 4)
            
            Text(qaItem.answer.isEmpty ? "no_answer_yet".localizedString() : qaItem.answer)
                .font(.body)
                .foregroundColor(qaItem.answer.isEmpty ? .secondary : .primary)
                .lineLimit(nil)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
    }
}

struct ProductQAView_Previews: PreviewProvider {
    static var previews: some View {
        ProductQAView(productId: "1")
    }
}
