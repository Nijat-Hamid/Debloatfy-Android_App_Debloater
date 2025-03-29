//
//  NavigationItemView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//

import SwiftUI

struct NavigationItemView: View {
    @Environment(\.router) private var router
    @Environment(\.auth) private var auth
    @State private var isHovered: Bool = false
    let navigationItem: NavigationItem
    
    private var isActive:Bool {
        router.currentPage == navigationItem.type
    }
    
    private var isDisabled:Bool {
        return !auth.isAccessed && (navigationItem.type != .about && navigationItem.type != .overview)
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
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(.primary, .brand)
                    .frame(width: 16)
                    .scaleEffect(isHovered && !isActive && !isDisabled ? 1.2 : 1.0)
                
                Text(navigationItem.title)
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .contentShape(Rectangle())
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .fontWeight(.medium)
            .background((isHovered || isActive) && !isDisabled ? Color.gray.opacity(0.2) : Color.clear)
            .clipShape(.rect(cornerRadius: 8))
            .animation(.snappy, value: isHovered)
        }
        .disabled(isDisabled)
        .onHover{ hovering in
            isHovered = hovering
        }
        .buttonStyle(.plain)
        .pointerStyle(isDisabled ? .default : .link)
    }
}

#Preview {
    NavigationItemView(navigationItem: NavigationItem.mock)
            .modifier(PreviewMod(type: .none))
}
