//
//  AppActionsView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//

import SwiftUI

struct AppActionsView: View {
    @Environment(\.debloatVM) private var debloatVM
  
    
    private let width:CGFloat
    private let type:AppListType
    private let item: AppListModel
    
    init(
        type:AppListType,
        width: CGFloat,
        item:AppListModel,
    ) {
        self.width = width
        self.type = type
        self.item = item
    }
    
    var body: some View {
        HStack(spacing:8) {
            AppActionItem(title: type.btnOne, icon: "arrow.trianglehead.2.clockwise",size: 12,type: .success) {
                debloatVM.openSheet(type: .backup, package: item.package)
            }
            
            AppActionItem(title: type.btnTwo, icon: "arrow.up.trash",size: 12,type: .warning) {
                debloatVM.openSheet(type: .backupRemove, package: item.package)
            }
            
            AppActionItem(title: "Remove", icon: "trash",size: 12,type: .danger) {
                debloatVM.openSheet(type: .remove, package: item.package)
            }
        }
        .frame(width:width)
    }
}

#Preview {
    AppActionsView(type: .debloat, width: 92, item: AppListModel.mock)
        .modifier(PreviewMod(type:.card))
}
