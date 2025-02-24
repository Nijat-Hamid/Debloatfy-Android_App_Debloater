//
//  NavigationItemView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//

import SwiftUI

struct NavigationItemView: View {
    @State private var isHovered: Bool = false
    @Environment(\.router) private var router
    let navigationItem: NavigationItem
    
    var isActive:Bool {
        router.currentPage == navigationItem.type
    }
    
    var body: some View {
        Button {
            if !isActive {
                withAnimation {
                    router.setView(for: navigationItem.type)
                }
            }
        } label: {
            HStack {
                Image(systemName: navigationItem.icon)
                    .symbolRenderingMode(.palette)
                    .resizable()
                    .foregroundStyle(.foregroundPrimary, .brand)
                    .frame(width: 16, height: 16)
                    .scaleEffect(isHovered && !isActive ? 1.2 : 1.0)
                
                Text(navigationItem.title)
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .fontWeight(.medium)
            .background(isHovered || isActive  ? Color.hover : Color.clear)
            .clipShape(.rect(cornerRadius: 8))
            .animation(.snappy, value: isHovered)
        }
        .onHover{ hovering in
            isHovered = hovering
        }
        .buttonStyle(.plain)
        
    }
}

#Preview {
    NavigationItemView(navigationItem: .init(type: .overview))
}
