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
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.backgroundCard.ignoresSafeArea())
        .navigationSplitViewColumnWidth(150)
        .modifier(ColorSchemeTransition())
    }
}

#Preview {
    SidebarView()
}
