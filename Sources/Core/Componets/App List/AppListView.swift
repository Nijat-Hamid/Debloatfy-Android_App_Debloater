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
    private let data:[AppListModel]
    private let isLoading:Bool
    private let searchText:String
    
    init(data:[AppListModel],
         type: AppListType = .debloat,
         isLoading:Bool,
         searchText:String
    ) {
        self.type = type
        self.data = data
        self.isLoading = isLoading
        self.searchText = searchText
    }
    
    var body: some View {
        VStack(spacing: 12) {
            AppListHeader(checkingItems: data)
            Group {
                if isLoading {
                    LoadingView()
                } else {
                    List {
                        ForEach(data) { item in
                            AppListItem(item: item,type: type)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 4, leading: -8, bottom: 4, trailing: 0))
                        }
                    }
                    .padding(.trailing, -16)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .modifier(UnavailableMod(type: data.isEmpty ? (searchText.isEmpty ? .empty : .search ) : .none))
                }
            }
        }
        .modifier(SectionMod(sectionType: .fullWidth))
    }
}

#Preview {
    AppListView(data: AppListModel.mockList,isLoading: false, searchText: "")
        .modifier(PreviewMod(width: 790))
}
