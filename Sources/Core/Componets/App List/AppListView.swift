//
//  AppListView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/15/25.
//

import SwiftUI

enum AppListType {
    case debloat
    case restore
    
    var btnOne:String {
        switch self {
        case .debloat: return "Backup"
        case .restore: return "Restore"
        }
    }
    
    var btnTwo:String {
        switch self {
        case .debloat: return "Backup&Remove"
        case .restore: return "Restore&Remove"
        }
    }
}

struct AppListView: View {
    
    private let type:AppListType
    
    init(type: AppListType = .debloat) {
        self.type = type
    }
    
    var body: some View {
        VStack(spacing: 12) {
            AppListHeader()
            List {
                ForEach(0..<100) { item in
                    AppListItem(item: item,type: type)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 4, leading: -8, bottom: 4, trailing: 0))
                }
            }
            .padding(.trailing, -16)
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .modifier(SectionMod(sectionType: .fullWidth))
    }
}

#Preview {
    AppListView()
}
