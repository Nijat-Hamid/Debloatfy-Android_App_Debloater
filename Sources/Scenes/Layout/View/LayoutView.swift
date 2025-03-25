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
    @State private var isAviable = true
    var body: some View {
        HSplitView {
            SidebarView()
            if isAviable {
                ZStack {
                    router.makeView(for: router.currentPage)
                        .modifier(PageMod())
                        .modifier(BlurryTransitionMod())
                }
            } else {
                ContentUnavailableView {
                    Text("Unaviable")
                } description: {
                    Text("No Content")
                }
                .background(VisualEffect(.card))
                .modifier(PageMod())
                .modifier(BlurryTransitionMod())

            }
            
        }
    }
}

#Preview {
    LayoutView()
}
