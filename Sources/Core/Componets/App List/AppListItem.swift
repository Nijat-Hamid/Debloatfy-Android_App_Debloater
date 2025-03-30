//
//  AppListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct AppListItem: View {
    
    @State private var isHovered:Bool = false
    @State private var check:Bool = false
    
    private var item:Int
    private let type:AppListType
    
    init(item: Int,type:AppListType) {
        self.item = item
        self.type = type
    }
    
    var body: some View {
        HStack(spacing:10) {
            Toggle("", isOn: $check)
                .toggleStyle(ToggleStyles(color: .brand))
                .frame(width: 30,alignment: .leading)
            AppListItemLabel(label: "com.google.android.apps.docs.editors.sheets",width: 280,withIcon: true)
            Spacer()
            AppListItemLabel(label: "System",width: 60,alignment: .center)
            Spacer()
            AppListItemLabel(label: "44.3MB",width: 70,alignment: .center)
            Spacer()
            AppActionsView(type:type,width: 192)
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
    AppListItem(item: 1, type: .debloat)
        .modifier(PreviewMod(type: .card,width: 400))
}
