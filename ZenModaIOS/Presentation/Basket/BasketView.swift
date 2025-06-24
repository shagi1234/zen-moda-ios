//
//  BasketView.swift
//  ZenModaIOS
//
//  Created by Shahruh on 24.06.2025.
//

import SwiftUI

struct BasketView: View {
    var scrollToTopCallback: ((@escaping () -> Void) -> Void)?
    
    var body: some View {
        Text("Basket")
    }
}

#Preview {
    BasketView()
}
