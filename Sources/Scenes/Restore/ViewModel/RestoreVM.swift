//
//  RestoreVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/8/25.
//
import SwiftUI

@Observable
final class RestoreVM {
    
    private let auth: Auth
    private(set) var selectManager: SelectManager
    
    init(auth:Auth = Auth.shared, selectManager:SelectManager = SelectManager()) {
        self.auth = auth
        self.selectManager = selectManager
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
        
        defer {
            isProceeding = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        await singleRestore()
        await singleDelete()
    }
    
    func bulkRestoreAndRemove() async {
        isProceeding = true
        
        defer {
            isProceeding = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        await bulkRestore()
        await bulkDelete()
    }
    
    func singleRestore() async {
        isProceeding = true
        
        defer {
            isProceeding = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        guard FileKit.existsBackupDir,
              FileKit.existsBackupJson
        else { return }
            
        if FileKit.existsApkDir(packageName) {
            do {
                let apkDir = FileKit.returnApkDir(packageName).path()
                let apkContents = try FileKit.manager.contentsOfDirectory(atPath: apkDir)
                let apkSplitBundle = apkContents.filter { $0.hasSuffix(".apk")}.map { "\(apkDir)/\($0)" }.joined(separator: " ")
                guard let result = await ADB.run(arguments: [.restoreApk(apkSplitBundle)]) else {return}
                let _ = result.contains("Success")
                
            } catch {
                print("Error reading apk directory for \(packageName):\(error.localizedDescription)")
            }
        }
    }
    
    func bulkRestore() async {
        isProceeding = true
        
        defer {
            isProceeding = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        guard FileKit.existsBackupDir,
              FileKit.existsBackupJson
        else { return }
        
        await withTaskGroup { group in
            for package in selectManager.selectedItems {
                if FileKit.existsApkDir(package) {
                    do {
                        let apkDir = FileKit.returnApkDir(package).path()
                        let apkContents = try FileKit.manager.contentsOfDirectory(atPath: apkDir)
                        let apkSplitBundle = apkContents.filter { $0.hasSuffix(".apk")}.map { "\(apkDir)/\($0)" }.joined(separator: " ")
                        group.addTask {
                            guard let result = await ADB.run(arguments: [.restoreApk(apkSplitBundle)]) else {return}
                            let _ = result.contains("Success")
                        }
                        
                    } catch {
                        print("Error reading apk directory for \(package):\(error.localizedDescription)")
                    }
                }
            }
            
            await group.waitForAll()
        }
    }
    
    func bulkDelete() async {
        isProceeding = true
        
        defer {
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000 )
                isProceeding = false
            }
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        do {
            guard FileKit.existsBackupDir,
                  FileKit.existsBackupJson
            else { return }
            
            let existingData = try Data(contentsOf: FileKit.backupJson)
            
            if var jsonDict = try JSONSerialization.jsonObject(with: existingData) as? [String: [String: Any]] {
                await withThrowingTaskGroup { group in
                    for packageName in selectManager.selectedItems {
                        group.addTask {
                            do {
                                if FileKit.existsApkDir(packageName) {
                                    try FileKit.manager.removeItem(at: FileKit.returnApkDir(packageName))
                                    return (packageName, true)
                                } else {
                                    return (packageName, false)
                                }
                            } catch {
                                print("Remove error: \(packageName): \(error.localizedDescription)")
                                return (packageName, false)
                            }
                        }
                    }
                    
                    do {
                        for try await (packageName, isSuccess) in group {
                            if isSuccess {
                                deviceAppList.removeAll(where: { $0.package == packageName })
                                jsonDict.removeValue(forKey: packageName)
                            }
                        }
                    } catch {
                        print("An error occurred during tasks: \(error.localizedDescription)")
                    }
                }
                
                selectManager.resetAllSelect()
                
                let updatedData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                try updatedData.write(to: FileKit.backupJson)
            }
        } catch {
            print("An error occurred during tasks: \(error.localizedDescription)")
        }
        
    }
    
    func singleDelete() async {
        isProceeding = true
        
        defer {
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000 )
                isProceeding = false
            }
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        guard !packageName.isEmpty else { return }
        
        do {
            guard FileKit.existsBackupDir,
                  FileKit.existsBackupJson
            else { return }
            
            let existingData = try Data(contentsOf: FileKit.backupJson)
            
            if var jsonDict = try JSONSerialization.jsonObject(with: existingData) as? [String: [String: Any]] {
                do {
                    if FileKit.existsApkDir(packageName) {
                        try FileKit.manager.removeItem(at: FileKit.returnApkDir(packageName))
                    }
                    
                    deviceAppList.removeAll(where: { $0.package == packageName })
                    jsonDict.removeValue(forKey: packageName)
                    
                    selectManager.removeSelected(packageName)
                    
                    let updatedData = try JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted)
                    
                    try updatedData.write(to: FileKit.backupJson)
                } catch {
                    print("Remove error: \(packageName): \(error.localizedDescription)")
                }
            }
    
            
        } catch {
            print("An error occurred during tasks: \(error.localizedDescription)")
        }
        
    }
    
    func getAppsFromPC() async {
        isLoading = true
        deviceAppList = []
        
        defer {
            Task {
                try? await Task.sleep(nanoseconds: 500_000_000 )
                isLoading = false
            }
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
        
        do {
            guard FileKit.existsBackupDir,
                  FileKit.existsBackupJson
            else {  return  }
            
            let existingData = try Data(contentsOf: FileKit.backupJson)
            
            if let jsonDict = try JSONSerialization.jsonObject(with: existingData) as? [String: [String: Any]] {
                for (packageName, packageInfo) in jsonDict {
                    if FileKit.existsApkDir(packageName) {
                        let appTypeString = packageInfo["appType"] as? String ?? "Unknown"
                        
                        let appType: ListAppType = appTypeString == "System" ? .system : .user
                        
                        let sizeString = packageInfo["totalSize"] as? String ?? "N/A"
                        
                        deviceAppList.append(.init(package: packageName, type: appType, size: sizeString))
                    }
                }
            }
            
            deviceAppList.sort { app1, app2 in
                let size1 = Double(app1.size) ?? 0.0
                let size2 = Double(app2.size) ?? 0.0
                return size1 > size2
            }
            
        } catch {
            print("Error during backup process: \(error.localizedDescription)")
        }
    }
}
