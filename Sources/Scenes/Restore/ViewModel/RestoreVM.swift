//
//  RestoreVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/8/25.

import SwiftUI

@MainActor @Observable
final class RestoreVM {
    private let auth: Auth
    private(set) var selectManager: SelectManager
    private let dbService: DBService
    
    init(auth:Auth = Auth.shared, selectManager:SelectManager = SelectManager(),dbService:DBService = .shared) {
        self.auth = auth
        self.selectManager = selectManager
        self.dbService = dbService
    }
    
    private(set) var isLoading:Bool = false
    private(set) var deviceAppList:[AppListModel] = []
    private(set) var isProceeding:Bool = false
    private(set) var packageName:String = ""
    var showActionSheet:Bool = false
    var sheetType: ConfirmationSheet.SheetType = .backup
    
    func openSheet(type:ConfirmationSheet.SheetType, package:String) {
        sheetType = type
        packageName = package
        showActionSheet = true
    }
    
    func closeSheet() {
        showActionSheet = false
        packageName = ""
    }
    
    func singleRestoreAndRemove() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await singleRestore()
        await singleDelete()
        
        isProceeding = false
    }
    
    func bulkRestoreAndRemove() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await bulkRestore()
        await bulkDelete()
        
        isProceeding = false
    }
    
    func singleRestore() async {
        isProceeding = true
        
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        guard FileKit.existsBackupDir,
              FileKit.existsBackupJson
        else { return }
        
        let result = await Processors.restoreSingleApp(packageName)
        
        if result {
            try? await dbService.save(.init(name:packageName, type: .restore,to: "Phone"))
        }
        
        isProceeding = false
    }
    
    func bulkRestore() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        guard FileKit.existsBackupDir,
              FileKit.existsBackupJson
        else { return }
        
        let result = await Processors.restoreMultipleApp(selectManager.selectedItems)
        
        for (package, isSuccess) in result where isSuccess {
            try? await dbService.save(.init(name: package, type: .restore, to: "Phone"))
        }
        
        isProceeding = false
    }
    
    func bulkDelete() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let result = await Processors.deleteRestoredApps(selectManager.selectedItems)
        
        for (package, isSuccess) in result where isSuccess {
            deviceAppList.removeAll(where: { $0.package == package })
            selectManager.resetAllSelect()
            try? await dbService.save(.init(name:package, type: .remove,from: "PC"))
        }
        
        try? await Task.sleep(for: .seconds(0.5))
        isProceeding = false
    }
    
    func singleDelete() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        guard !packageName.isEmpty else { return }
        
        let result = await Processors.deleteRestoredApp(packageName)
        
        if result {
            deviceAppList.removeAll(where: { $0.package == packageName })
            selectManager.removeSelected(packageName)
            try? await dbService.save(.init(name:packageName, type: .remove,from: "PC"))
        }
        
        try? await Task.sleep(for: .seconds(0.5))
        isProceeding = false
    }
    
    func getAppsFromPC() async {
        isLoading = true
        deviceAppList = []
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let result = await Processors.getRestoredApps()
        
        deviceAppList = result
        
        try? await Task.sleep(for: .seconds(0.3))
        isLoading = false
    }
}
