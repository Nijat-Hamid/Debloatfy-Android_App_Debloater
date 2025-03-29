//
//  DebugImageView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/3/25.
//

import SwiftUI

struct DebugImageView: View {
    var body: some View {
        Image(systemName: "cable.connector.slash")
            .font(.system(size: 100))
            .symbolRenderingMode(.palette)
            .foregroundStyle(.primary, .brand)
    }
}

#Preview {
    DebugImageView()
}
