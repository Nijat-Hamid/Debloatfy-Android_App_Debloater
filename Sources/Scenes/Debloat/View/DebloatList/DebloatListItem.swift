//
//  DebloatListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct DebloatListItem: View {
    
    @State private var isHovered:Bool = false
    @State private var check:Bool = false
    
    private var item:Int
    
    init(item: Int) {
        self.item = item
    }
    
    var body: some View {
        HStack(spacing:10) {
            Toggle("", isOn: $check)
                .toggleStyle(ToggleStyles(color: .brand))
                .frame(width: 30,alignment: .leading)
            
            DebloatListItemLabel(label: "Facebook",width: 120, withIcon: true)
            Spacer()
            DebloatListItemLabel(label: "com.package.facebook",width: 180,alignment: .center)
            Spacer()
            DebloatListItemLabel(label: "System",width: 60,alignment: .center)
            Spacer()
            DebloatListItemLabel(label: "44.3MB",width: 70,alignment: .center)
            Spacer()
            AppActionsView(width: 192)            
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(isHovered ? 0.5 : 0.2))
                .animation(.snappy, value: isHovered)
        }
        .frame(width:792)
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation {
                isHovered = hovering
            }
        }
        
    }
}

#Preview {
    DebloatListItem(item: 1)
        .modifier(PreviewMod(type: .card,width: 400))
}
