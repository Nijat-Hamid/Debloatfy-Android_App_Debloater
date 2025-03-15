//
//  DebugImageView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/3/25.
//

import SwiftUI

struct DebugImageView: View {
    @State private var isScaled: Bool = false
    var body: some View {
        Image(systemName: "cable.connector.slash")
            .font(.system(size: 100))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.primary, .brand)
            .scaleEffect(isScaled ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: isScaled)
            .onAppear {
                isScaled = true
            }
    }
}

#Preview {
    DebugImageView()
}
