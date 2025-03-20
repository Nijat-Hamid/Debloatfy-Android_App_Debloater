//
//  AppActionsView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//

import SwiftUI

struct AppActionsView: View {
    private let width:CGFloat
    
    init(width: CGFloat) {
        self.width = width
    }
    
    var body: some View {
        HStack(spacing:8) {
            AppActionItem(title: "Backup", icon: "arrow.trianglehead.2.clockwise",size: 12,type: .success) {
                print("pressed")
            }
            
            AppActionItem(title: "Backup&Remove", icon: "arrow.up.trash",size: 12,type: .warning) {
                print("pressed")
            }
            
            AppActionItem(title: "Remove", icon: "trash",size: 12,type: .danger) {
                print("pressed")
            }
        }
        .frame(width:width)
    }
}

#Preview {
    AppActionsView(width: 92)
        .modifier(PreviewMod(type:.card))
}
