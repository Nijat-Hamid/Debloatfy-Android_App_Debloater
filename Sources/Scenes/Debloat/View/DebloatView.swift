//
//  DebloatView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct DebloatView: View {
    @State private var vm = DebloatVM()
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
                refreshAction: vm.getDeviceApps,
                removeAction: vm.bulkDeleteApps,
                primaryAction: vm.bulkBackupApps,
                secondaryAction: vm.bulkBackupAndRemove,
                isLoading: vm.isLoading,
                searchText: $searchText,
                isProceeding: vm.isProceeding
            )
            AppListView(
                data: filteredDeviceAppList,
                isLoading: vm.isLoading,
                searchText: searchText
            )
            .environment(\.debloatVM,vm)
           
        }
        .environment(vm.selectManager)
        .sheet(isPresented: $vm.showActionSheet) {
            ConfirmationSheet(
                type: $vm.sheetType,
                isProceeding: vm.isProceeding,
                appCount: 1
            ) {
                Task {
                    switch vm.sheetType {
                    case .remove:
                        await vm.singleDeleteApp()
                    case .backup,.restore:
                        await vm.singleBackup()
                    case .backupRemove,.restoreRemove:
                        await vm.singleBackupAndRemove()
                    }
                    await MainActor.run {
                        vm.closeSheet()
                    }
                }
            }
            .interactiveDismissDisabled()
        }
        .task {
            await vm.getDeviceApps()
        }
    }
}

#Preview {
    DebloatView()
}
