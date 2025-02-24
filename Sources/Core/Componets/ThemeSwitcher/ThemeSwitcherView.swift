//
//  ThemeSwitcherView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/21/25.
//

import SwiftUI

struct ThemeSwitcherView: View {
    @State private var isHovered: Bool = false
    @AppStorage("isDark") private var isDark:Bool = true

    var body: some View {
        Button {
            isDark.toggle()
        } label: {
            HStack(spacing: isDark ? 4: 8) {
                ThemeIconView(isDark: isDark)
                Text(isDark ? "Dark Mode" :"Light Mode")
                    .font(.appTitle3)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .onHover{ hovering in
            isHovered = hovering
        }
        .buttonStyle(.plain)
        .padding(.vertical, 4)
        .padding(.horizontal, 6)
        .background(isHovered ? Color.hover : Color.clear)
        .preferredColorScheme(isDark ? .dark : .light)
        .clipShape(.rect(cornerRadius: 8))
        .animation(.snappy, value: isHovered)
    }
}

#Preview {
    ThemeSwitcherView()
        .frame(width: 200,height: 50)
}
