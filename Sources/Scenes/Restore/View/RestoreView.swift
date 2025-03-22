//
//  RestoreView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct RestoreView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AppToolbarView(type: .restore)
            AppListView()
        }
    }
}

#Preview {
    RestoreView()
}
