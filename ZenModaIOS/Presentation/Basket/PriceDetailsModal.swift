//
//  PriceDetailsModal.swift
//  ZenModaIOS
//
//  Created by Shahruh on 17.07.2025.
//

import SwiftUI

struct PriceDetailsModal: View {
    let subtotal: String
    let delivery: String
    let discount: String
    let total: String
    let onConfirm: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("price_breakdown".localizedString())
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: { onConfirm() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            
            // Price breakdown
            VStack(spacing: 0) {
                PriceRow(
                    title: "subtotal".localizedString(),
                    amount: subtotal
                )
                
                PriceRow(
                    title: "delivery_fee".localizedString(),
                    amount: delivery
                )
                
                PriceRow(
                    title: "discount".localizedString(),
                    amount: discount,
                    isDiscount: true
                )
                
                // Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                
                // Total
                HStack {
                    Text("total_price".localizedString())
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("405 TMT")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
            .background(Color.white)
            
            // Bottom section
            VStack(spacing: 16) {
                Button(action: onConfirm) {
                    Text("confirm_cart".localizedString())
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(height: 48)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 34)
            }
            .background(Color.white)
        }
        .frame(height: 350)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
        .padding()
    }
}

struct PriceRow: View {
    let title: String
    let amount: String
    let isDiscount: Bool
    
    init(title: String, amount: String, isDiscount: Bool = false) {
        self.title = title
        self.amount = amount
        self.isDiscount = isDiscount
    }
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(amount)
                .font(.system(size: 16))
                .foregroundColor(isDiscount ? .red : .primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
