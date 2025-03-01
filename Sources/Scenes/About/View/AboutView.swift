//
//  AboutView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                InfoView()
                ChangelogView()
            }
        }
    }
}

#Preview {
    AboutView()
        .modifier(PreviewMod())
}
