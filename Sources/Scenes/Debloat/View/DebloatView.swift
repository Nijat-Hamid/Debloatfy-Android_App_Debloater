//
//  DebloatView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct DebloatView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AppToolbarView()
            AppListView()
        }
    }
}

#Preview {
    DebloatView()
        .modifier(PreviewMod(type: .card,width: nil))
}
