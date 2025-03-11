//
//  LayoutView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/15/25.
//

import SwiftUI

struct LayoutView: View {
    @State private var vm = LayoutVM()
    @Environment(\.router) private var router
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            router.makeView(for: router.currentPage)
                                .modifier(PageMod())
                                .modifier(BlurryTransitionMod())
        }

//        HSplitView {
//            SidebarView()
//            ZStack {
//                router.makeView(for: router.currentPage)
//                    .modifier(PageMod())
//                    .modifier(BlurryTransitionMod())
//            }
//        }
    }
}

#Preview {
    LayoutView()
}
