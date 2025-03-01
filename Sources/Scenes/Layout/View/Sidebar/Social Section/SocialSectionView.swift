//
//  SocialSectionView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/21/25.
//

import SwiftUI

struct SocialSectionView: View {
    
    let socialData: [Section<SocialItem>]
    @State private var hoveredItemId: UUID?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(socialData) { section in
                VStack(alignment: .leading, spacing: 2) {
                    Text(section.title)
                        .font(.appHeadline)
                        .foregroundStyle(Color.mute)
                        .padding(.horizontal, 8)
                    
                    HStack(spacing: 4) {
                        ForEach(section.items) { item in
                            SocialItemView(
                                socialItem: item,
                                isHoveredItem: hoveredItemId == item.id)
                            .onHover { hovering in
                                withAnimation(.snappy) {
                                    hoveredItemId = hovering ? item.id : nil
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    SocialSectionView(socialData: [.init(title: "Social", items: SocialItem.mockList)])
        .modifier(PreviewMod(width: 180))
}
