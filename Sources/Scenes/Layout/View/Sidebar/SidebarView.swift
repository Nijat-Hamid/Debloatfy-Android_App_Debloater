//
//  SwiftUIView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/14/25.
//

import SwiftUI

struct SidebarView: View {
    @Environment(\.layoutVM) private var vm
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                NavigationSectionView(navigationData: vm.navData)
                SocialSectionView(socialData: vm.socialData)
                OthersSectionView()
            }
            .padding(.all, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minWidth:150, maxWidth: 150, maxHeight: .infinity)
        .background(Color.backgroundCard.ignoresSafeArea())
        .modifier(ColorSchemeTransition())
    }
}

#Preview {
    SidebarView()
        .modifier(PreviewMod(padding: 0))
}
