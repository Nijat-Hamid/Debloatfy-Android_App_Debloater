//
//  DebloatVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/29/25.
//
import SwiftUI

@MainActor @Observable
final class DebloatVM {
    private let auth: Auth
    private(set) var selectManager: SelectManager
    private let dbService: DBService
    
    init(auth:Auth = Auth.shared, selectManager:SelectManager = SelectManager(), dbService:DBService = .shared) {
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
    
    func singleBackupAndRemove() async {
        isProceeding = true
  
        await auth.startServer()
        
        guard auth.isAccessed, !packageName.isEmpty else { return }
        
        await singleBackup()
        await singleDeleteApp()
        
        isProceeding = false
    }
    
    func singleBackup() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed,
              !packageName.isEmpty,
              let systemApk = deviceAppList.filter({ $0.package == packageName}).first,
              systemApk.type != .system
        else { return }
        
        let result = await Processors.singleBackupApp(packageName, deviceAppList: deviceAppList)
        
        if result {
            try? await dbService.save(.init(name:packageName, type: .backup, to: "PC"))
        }
        
        isProceeding = false
    }
    
    func singleDeleteApp() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed,!packageName.isEmpty else { return }
        
        let result = await Processors.deleteSingleApp(packageName)
        
        if result {
            deviceAppList.removeAll(where: { $0.package == packageName })
            selectManager.removeSelected(packageName)
            try? await dbService.save(.init(name:packageName,type: .remove,from: "Phone"))
        }
        
        isProceeding = false
    }
    
    func bulkDeleteApps() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let result = await Processors.deleteMultipleApps(selectManager.selectedItems)
        
        for (package, isSuccess) in result where isSuccess {
            deviceAppList.removeAll(where: { $0.package == package })
            selectManager.removeSelected(package)
            try? await dbService.save(.init(name:package,type: .remove,from: "Phone"))
        }
        
        isProceeding = false
    }
    
    func bulkBackupAndRemove() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await bulkBackupApps()
        
        await bulkDeleteApps()
        
        isProceeding = false
    }
    
    
    func bulkBackupApps() async {
        isProceeding = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let result = await Processors.bulkBackupApps(selectManager.selectedItems, deviceAppList: deviceAppList)
        
        for package in result {
            try? await dbService.save(.init(name:package, type: .backup,to: "PC"))
        }
        
        isProceeding = false
    }
    
    
    
    func getDeviceApps() async {
        isLoading = true
        deviceAppList = []
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let systemApps = await Processors.getDeviceApps(type: .system, arguments: .getListSystemApps)
        let userApps = await Processors.getDeviceApps(type: .user, arguments: .getListUserApps)
        
        deviceAppList.append(contentsOf: systemApps)
        deviceAppList.append(contentsOf: userApps)
        
        deviceAppList.sort { app1, app2 in
            let size1 = Double(app1.size) ?? 0.0
            let size2 = Double(app2.size) ?? 0.0
            return size1 > size2
        }
        
        isLoading = false
    }
        
   
}

