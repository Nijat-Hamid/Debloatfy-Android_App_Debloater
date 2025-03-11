//
//  InfoView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/28/25.
//

import SwiftUI

struct InfoLogoView: View {
    var body: some View {
        Image("logo")
            .resizable()
            .frame(width: 150,height: 150)
            .modifier(SectionMod(sectionType: .automatic))
    }
}

#Preview {
    InfoLogoView()
        .modifier(PreviewMod(width: nil))
}
