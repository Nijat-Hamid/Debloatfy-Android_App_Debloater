//
//  LayoutView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//

import SwiftUI
import SwiftUIIntrospect

struct LayoutView: View {
    @State private var vm = LayoutVM()
    @Environment(\.router) private var router
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environment(\.layoutVM,vm)
                .toolbar(.hidden)
        } detail: {
            router.makeView(for: router.currentPage)
                .modifier(PageMod())
                .modifier(PageTransitionMod())
        }
        .modifier(SplitViewMod())
    }
}

#Preview {
    LayoutView()
}
