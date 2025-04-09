//
//  RestoreView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct RestoreView: View {
    @State private var vm = RestoreVM()
    @State private var searchText = ""
    
    private var filteredDeviceAppList:[AppListModel] {
        if searchText.isEmpty {
            return vm.deviceAppList
        } else {
            return vm.deviceAppList.filter { item in
                item.package.contains(searchText.lowercased())
            }
        }
    }
 
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            AppToolbarView(
                type: .restore,
                refreshAction: vm.getAppsFromPC,
                removeAction: vm.bulkDelete,
                primaryAction: vm.bulkRestore,
                secondaryAction: vm.bulkRestoreAndRemove,
                isLoading: vm.isLoading,
                searchText: $searchText,
                isProceeding: vm.isProceeding
            )
            AppListView(
                data: filteredDeviceAppList,
                type: .restore,
                isLoading: vm.isLoading,
                searchText: searchText
            )
            .environment(\.restoreVM,vm)
            
        }
        .environment(\.selectManager,vm.selectManager)
        .sheet(isPresented: $vm.showActionSheet) {
            ConfirmationSheet(
                type: $vm.sheetType,
                isProceeding: vm.isProceeding,
                appCount: 1
            ) {
                Task {
                    switch vm.sheetType {
                    case .remove:
                        await vm.singleDelete()
                    case .backup,.restore:
                        await vm.singleRestore()
                    case .backupRemove,.restoreRemove:
                        await vm.singleRestoreAndRemove()
                    }
                    DispatchQueue.main.async {
                        vm.closeSheet()
                    }
                }
            }
            .interactiveDismissDisabled()
        }
        .task {
            await vm.getAppsFromPC()
        }
    }
}

#Preview {
    RestoreView()
}
