//
//  AppListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct AppListItem: View {
    @Environment(SelectManager.self) private var selectManager
   
    private let item:AppListModel
    private let type:AppListType
    
    init(item: AppListModel,type:AppListType) {
        self.item = item
        self.type = type
    }
    
    var body: some View {
        HStack(spacing:10) {
            Toggle("", isOn: Binding(
                get: { selectManager.isSelected(package: item.package)},
                set: { _ in selectManager.toggle(package: item.package)}
            ))
                .toggleStyle(ToggleStyles(color: .brand))
                .frame(width: 30,alignment: .leading)
            AppListItemLabel(label: item.package,width: 280,withIcon: true)
            Spacer()
            AppListItemLabel(label: item.type.rawValue, width: 60,alignment: .center)
            Spacer()
            AppListItemLabel(label: Utils.formatSize(item.size),width: 70,alignment: .center)
            Spacer()
            AppActionsView(type:type,width: 192, item: item)
        }
        .padding(.horizontal,8)
        .frame(width:792,height: 38)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.2))
        }
    }
}

#Preview {
    AppListItem(item: AppListModel.mock, type: .debloat)
        .modifier(PreviewMod(type: .card,width: nil))
}
