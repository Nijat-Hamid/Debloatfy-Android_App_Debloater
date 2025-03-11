//
//  AboutView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            HStack(spacing:12) {
                InfoDetailView()
                InfoLogoView()
            }
            InfoPurposeView()
            Spacer()
        }
    }
}

#Preview {
    AboutView()
        .modifier(PreviewMod())
}
