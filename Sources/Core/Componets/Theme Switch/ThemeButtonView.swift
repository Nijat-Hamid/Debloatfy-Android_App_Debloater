//
//  ThemeButtonView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/21/25.
//

import SwiftUI

struct ThemeButtonView: View {
    @Environment(\.colorScheme) private var scheme
    @AppStorage("userTheme") private var userTheme:Theme = .dark
    @State private var isHovered: Bool = false
    @State private var changeTheme:Bool = false
    var body: some View {
        Button {
                changeTheme.toggle()
        } label: {
            HStack(spacing: 4) {
                ThemeIconView(scheme: scheme, size: CGSize(width: 16, height: 16))
                Text(userTheme.schemeTitle)
                    .font(.appTitle3)
                    .fontWeight(.semibold)
                Spacer()
            }
            .contentShape(Rectangle())
        }
        .onHover{ hovering in
            isHovered = hovering
        }
        .popover(isPresented: $changeTheme, attachmentAnchor: .point(.trailing), arrowEdge: .trailing) {
            ThemeSwitchView(scheme: scheme)
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(isHovered ? Color.hover : Color.clear)
        .clipShape(.rect(cornerRadius: 8))
        .animation(.snappy, value: isHovered)
    }
}

#Preview {
    ThemeButtonView()
        .modifier(PreviewMod())
}
