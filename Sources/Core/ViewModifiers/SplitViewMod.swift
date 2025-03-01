//
//  SplitViewMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/28/25.
//

import SwiftUI
import SwiftUIIntrospect

struct SplitViewMod:ViewModifier {
    func body(content: Content) -> some View {
        content
            .introspect(.navigationSplitView, on: .macOS(.v13,.v14,.v15)) { splitView in
                if let delegate = splitView.delegate as? NSSplitViewController {
                    delegate.splitViewItems.first?.canCollapse = false
                    delegate.splitViewItems.first?.canCollapseFromWindowResize = false
                    delegate.splitView.setValue(NSColor.clear, forKey: "dividerColor")
                    delegate.splitView.dividerStyle = .thin
                }
            }
    }
    
}
