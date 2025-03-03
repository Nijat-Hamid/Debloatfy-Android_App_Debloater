//
//  AboutView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(alignment: .leading) {
            InfoView()
            Spacer()
        }
    }
}

#Preview {
    AboutView()
        .modifier(PreviewMod())
}
