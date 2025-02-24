//
//  SidebarSocialView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/21/25.
//

import SwiftUI

struct SocialItemView: View {
    
    let socialItem: SocialItem
    var isHoveredItem: Bool
        
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        Button {
            if let url = URL(string: socialItem.url) {
                openURL(url)
            }
        } label: {
            HStack(spacing:4) {
                Image(socialItem.icon)
                    .resizable()
                    .foregroundStyle(isHoveredItem ? .brand : .primary)
                    .frame(width: 22, height: 22)
                    
                    .animation(.snappy, value: isHoveredItem)
                ZStack {
                    if isHoveredItem {
                        Text(socialItem.name)
                            .font(.appSubHeadline)
                            .transition(.opacity)
                    }
                }
                .frame(width: isHoveredItem ? nil : 0, alignment: .leading)
                
            }
            .padding(.vertical, 2)
            .padding(.horizontal, 6)
            .background(isHoveredItem ? Color.hover : Color.clear)
            .clipShape(.rect(cornerRadius: 8))
            .animation(.snappy, value: isHoveredItem)
        }
        .buttonStyle(.plain)
        .animation(.snappy, value: isHoveredItem)
        
    }
}

#Preview {
    SocialItemView(socialItem: .init(name: "Linkedin", url: "", icon: "linkedin"), isHoveredItem: true)
}
