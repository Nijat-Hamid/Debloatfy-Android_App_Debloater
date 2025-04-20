//
//  LayoutView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//

import SwiftUI

struct LayoutView: View {
    @Environment(Router.self) private var router
    @Environment(Auth.self) private var auth
    @State private var vm = LayoutVM()
    
    private var currentPage:Route {
        !auth.isAccessed && router.currentPage != .about ? router.debugPage : router.currentPage
    }
    
    var body: some View {
        HSplitView {
            SidebarView()
                .environment(\.layoutVM,vm)
            ZStack {
                router.makeView(for: currentPage)
                    .modifier(PageMod())
                    .modifier(OpacityTransitionMod())
            }
        }
    }
}

#Preview {
    LayoutView()
}
