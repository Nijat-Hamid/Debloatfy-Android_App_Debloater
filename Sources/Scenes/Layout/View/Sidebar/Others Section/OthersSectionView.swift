//
//  OthersSectionView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/21/25.
//

import SwiftUI

struct OthersSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("OTHERS")
                .font(.appHeadline)
                .foregroundStyle(Color.mute)
                .padding(.horizontal, 8)
            
            VStack(alignment: .leading, spacing: 6) {
                ThemeSwitcherView()
            }
        }
    }
}

#Preview {
    OthersSectionView()
        .modifier(PreviewMod())
}
