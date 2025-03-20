//
//  DebloatListView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct DebloatListView: View {
    var body: some View {
        VStack(spacing: 12) {
            DebloatListHeader()
            List {
                ForEach(0..<100) { item in
                    DebloatListItem(item: item)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: -8, bottom: 4, trailing: 0))
                }

            }
            .padding(.trailing, -16)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .modifier(SectionMod(sectionType: .fullWidth))
    }
}

#Preview {
    DebloatListView()
}
