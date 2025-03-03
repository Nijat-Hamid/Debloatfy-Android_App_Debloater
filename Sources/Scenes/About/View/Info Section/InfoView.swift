//
//  InfoView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/28/25.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
            VStack(spacing: 16) {
                HStack(alignment: .center) {
                    InfoDetailView()
                    Spacer()
                    Image("logo")
                        .resizable()
                        .frame(width: 150,height: 150)
                }
                InfoPurposeView()
            }
            .modifier(SectionMod())
    }
}

#Preview {
    InfoView()
        .modifier(PreviewMod(width: nil))
}
