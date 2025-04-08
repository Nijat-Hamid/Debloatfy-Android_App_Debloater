//
//  AppListHeader.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

struct AppListHeader: View {
    @Environment(\.selectManager) private var selectManager
    private let checkingItems:[AppListModel]
    
    init(checkingItems:[AppListModel]) {
        self.checkingItems = checkingItems
    }
    
    var body: some View {
        HStack {
            Toggle("", isOn: Binding(
                get: { selectManager.allSelected },
                set: { newValue in
                    selectManager.allSelected = newValue
                    selectManager.toggleAll(items: checkingItems)
                }
            ))
                .toggleStyle(ToggleStyles(color: .brand))
                .padding(8)
                .background(Color.secondary.opacity(0.2),in: .rect(cornerRadius: 8))
            
            HStack(spacing:0) {
                Text("Package")
                    .padding(.leading,10)
                    .frame(width: 277,alignment: .leading)

                Spacer()
                
                Text("Type")
                    .frame(width: 60)
                
                Spacer()
                
                Text("Size")
                    .frame(width: 70)
                
                Spacer()
                
                Text("Actions")
                    .frame(width: 196)
                
            }
            .font(.appHeadline)
            .padding(8)
            .frame(maxWidth:.infinity)
            .background(Color.secondary.opacity(0.2),in: .rect(cornerRadius: 8))
        }
        
    }
}

#Preview {
    AppListHeader(checkingItems: AppListModel.mockList)
        .modifier(PreviewMod(type: .card,width: 500))
}
