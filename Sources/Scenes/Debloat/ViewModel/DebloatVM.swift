//
//  DebloatVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/29/25.
//
import SwiftUI

@Observable
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
        defer { isProceeding = false }
        
        await auth.startServer()
        
        guard auth.isAccessed, !packageName.isEmpty else { return }
        
        await singleBackup()
        await singleDeleteApp()
    }
    
    func singleBackup() async {
        isProceeding = true
        defer { isProceeding = false }
        
        await auth.startServer()
        
        guard auth.isAccessed,
              !packageName.isEmpty,
              let systemApk = deviceAppList.filter({ $0.package == packageName}).first,
              systemApk.type != .system
        else { return }
        
        do {
            if !FileKit.existsBackupDir {
                try FileKit.createBackupDirIfNeeded()
            }
            
            var allBackupInfo = loadExistingBackupInfo(from: FileKit.backupJson)
            
            let resultOfProcessing = await processPackage(packageName, backupsDirectory: FileKit.backupDir)
            
            allBackupInfo[packageName] = resultOfProcessing?.1
            
            try saveBackupInfo(allBackupInfo, to: FileKit.backupJson)
            try? await dbService.save(.init(name:packageName, type: .backup, to: "PC"))
            
        } catch {
            Log.of(.viewModel(DebloatVM.self)).error("Error during backup process: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func singleDeleteApp() async {
        isProceeding = true
        
        defer {
            isProceeding = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed,!packageName.isEmpty else { return }
        
        
        let result = await ADB.run(arguments: [.uninstallApk(packageName)])
        
        switch result {
        case .success:
            
            deviceAppList.removeAll(where: { $0.package == packageName })
            selectManager.removeSelected(packageName)
            try? await dbService.save(.init(name:packageName,type: .remove,from: "Phone"))
        case .failure(let error,_,_):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
        }
        
    }
    
    func bulkBackupAndRemove() async {
        isProceeding = true
        defer { isProceeding = false }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await bulkBackupApps()
        
        await bulkDeleteApps()
    }
    
    
    func bulkBackupApps() async {
        isProceeding = true
        defer { isProceeding = false }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        do {
            if !FileKit.existsBackupDir {
                try FileKit.createBackupDirIfNeeded()
            }
            
            var allBackupInfo = loadExistingBackupInfo(from: FileKit.backupJson)
            
            try await processPackagesInParallel(backupsDirectory: FileKit.backupDir, allBackupInfo: &allBackupInfo)
            
            try saveBackupInfo(allBackupInfo, to: FileKit.backupJson)
            
        } catch {
            Log.of(.viewModel(DebloatVM.self)).error("Error during backup process: \(error.localizedDescription)")
        }
    }
    
    
    func bulkDeleteApps() async {
        
        isProceeding = true
        
        defer {
            isProceeding = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await withTaskGroup { group in
            for package in selectManager.selectedItems {
                group.addTask {
                    let result = await ADB.run(arguments: [.uninstallApk(package)])
                    switch result {
                    case .success:
                        return (package, true)
                    case .failure(let error, _,_):
                        Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
                        return (package, false)
                    }
                }
            }
            
            for await (package, isSuccess) in group {
                if isSuccess {
                    deviceAppList.removeAll(where: { $0.package == package })
                    selectManager.removeSelected(package)
                    try? await dbService.save(.init(name:package,type: .remove,from: "Phone"))
                }
            }
        }
    }
    
    
    func getDeviceApps() async {
        
        isLoading = true
        
        deviceAppList = []
        
        defer {
            isLoading = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await processApps(type: .system, arguments: .getListSystemApps)
        await processApps(type: .user, arguments: .getListUserApps)
        
        sortAppsBySize()
    }
    
    
    private func loadExistingBackupInfo(from url: URL) -> [String: [String: Any]] {
        guard FileKit.manager.fileExists(atPath: url.path) else { return [:] }
        
        do {
            let existingData = try Data(contentsOf: url)
            return (try JSONSerialization.jsonObject(with: existingData) as? [String: [String: Any]]) ?? [:]
        } catch {
            Log.of(.viewModel(DebloatVM.self)).error("Warning: Could not read existing backup info: \(error.localizedDescription)")
            return [:]
        }
    }
    
    private func processPackagesInParallel(backupsDirectory: URL, allBackupInfo: inout [String: [String: Any]]) async throws {
        
        let results = await withTaskGroup { group in
            var packageResults = [(String, [String: Any])]()
            
            for package in selectManager.selectedItems {
                if let choosenApk = deviceAppList.filter({ $0.package == package}).first, choosenApk.type != .system {
                    group.addTask {
                        return await self.processPackage(package, backupsDirectory: backupsDirectory)
                    }
                }
            }
            
            for await result in group {
                if let result = result {
                    packageResults.append(result)
                }
            }
            
            return packageResults
        }
        
        for (package, info) in results {
            allBackupInfo[package] = info
            try? await dbService.save(.init(name:package, type: .backup,to: "PC"))
        }
    }
    
    private func processPackage(_ package: String, backupsDirectory: URL) async -> (String, [String: Any])? {
        
        let apkPath = await ADB.run(arguments: [.getApksFullPath(package)])
        
        switch apkPath {
        case .success(let output, _ ):
            
            let filteredApkPaths = output
                .split(separator: "\n")
                .filter { $0.hasPrefix("package:") }
                .map { $0.replacingOccurrences(of: "package:", with: "") }
            
            if filteredApkPaths.isEmpty {
                Log.of(.viewModel(DebloatVM.self)).info("No APKs found for package: \(package)")
                return nil
            }
            
            let packageDirectory = backupsDirectory.appending(path: package)
            
            do {
                if !FileKit.manager.fileExists(atPath: packageDirectory.path) {
                    try FileKit.manager.createDirectory(at: packageDirectory, withIntermediateDirectories: true)
                }
                
                
                var packageInfo: [String: Any] = [:]
                
                
                if let appInfo = self.deviceAppList.first(where: { $0.package == package }) {
                    packageInfo["appType"] = appInfo.type.rawValue
                    packageInfo["totalSize"] = appInfo.size
                }
                
                
                let apksInfo = try await pullApksInParallel(filteredApkPaths: filteredApkPaths, packageDirectory: packageDirectory)
                packageInfo["apks"] = apksInfo
                
                return (package, packageInfo)
            } catch {
                Log.of(.viewModel(DebloatVM.self)).error("Error processing package \(package): \(error.localizedDescription)")
                return nil
            }
            
            
        case .failure(let error, _, _):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
            return nil
        }
        
    }
    
    private func pullApksInParallel(filteredApkPaths: [String], packageDirectory: URL) async throws -> [[String: Any]] {
        return await withTaskGroup { group in
            var results = [[String: Any]]()
            
            for path in filteredApkPaths {
                group.addTask {
                    return await self.pullSingleApk(path: path, packageDirectory: packageDirectory)
                }
            }
            
            for await result in group {
                if let result = result {
                    results.append(result)
                }
            }
            
            return results
        }
    }
    
    
    private func pullSingleApk(path: String, packageDirectory: URL) async -> [String: Any]? {
        guard let lastSlashIndex = path.lastIndex(of: "/") else { return nil }
        
        let baseDir = String(path[..<lastSlashIndex])
        let fileName = URL(fileURLWithPath: path).lastPathComponent
        let destinationURL = packageDirectory.appendingPathComponent(fileName)
        
        
        let result = await ADB.run(arguments: [.backupApk(path, destinationURL.path)])
        switch result {
        case .success:
            return [
                "fileName": fileName,
                "originalPath": baseDir
            ]
        case .failure(let error,_,_):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
            return nil
        }
    }
    
    private func saveBackupInfo(_ info: [String: [String: Any]], to url: URL) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: info, options: .prettyPrinted)
        try jsonData.write(to: url)
    }
    
    
    private func sortAppsBySize() {
        deviceAppList.sort { app1, app2 in
            let size1 = Double(app1.size) ?? 0.0
            let size2 = Double(app2.size) ?? 0.0
            return size1 > size2
        }
    }
    
    private func processApps(type: ListAppType, arguments: ADB.Commands) async {
        let appList = await ADB.run(arguments: [arguments])
        
        switch appList {
        case .success(let output, _):
            let startTime = Date()
            defer {
                let endTime = Date()
                Log.of(.viewModel(DebloatVM.self)).info("Function completed: \(endTime.timeIntervalSince(startTime))")
            }
            
            let filteredOutput = output
                .split(separator: "\n")
                .filter { $0.starts(with: "package:") }
                .map { $0.replacingOccurrences(of: "package:", with: "")}
            
            
            await withTaskGroup { group in
                for packageName in filteredOutput {
                    group.addTask {
                        await self.getPackageSize(packageName: packageName)
                    }
                }
                
                for await (packageName, size) in group {
                    deviceAppList.append(.init(package: packageName, type: type, size: size))
                }
            }
        case .failure(let error, _, _):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
            return
        }
        
        
    }
    
    private func getPackageSize(packageName: String) async -> (String, String) {
        let apkPath = await ADB.run(arguments: [.getApksFullPath(packageName)])
        
        
        switch apkPath {
        case .success(let output, _):
            
            let filteredApkPath = output
                .split(separator: "\n")
                .filter { $0.starts(with: "package") }
                .map { $0.replacingOccurrences(of: "package:", with: "")}
            
            guard let firstPath = filteredApkPath.first,
                  let lastSlashIndex = firstPath.lastIndex(of: "/") else {
                return (packageName, "N/A")
            }
            
            let baseDir = String(firstPath[..<lastSlashIndex])
            
            
            let sizeOutput = await ADB.run(arguments: [.getApkSize(baseDir)])
            
            switch sizeOutput {
            case .success(let output, _):
                let validLines = output
                    .split(separator: "\n")
                    .filter {
                        !$0.lowercased().contains("permission denied") &&
                        !$0.starts(with: "du:") &&
                        $0.contains(baseDir)
                    }
                
                
                guard let sizeLine = validLines.first else {
                    return (packageName, "N/A")
                }
                
                let components = sizeLine.split(separator: "\t")
                guard let sizeComponent = components.first else {
                    return (packageName, "N/A")
                }
                
                return (packageName, String(sizeComponent))
                
            case .failure:
                return (packageName, "N/A")
            }
            
            
        case .failure(let error, _ , _ ):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
            return (packageName, "N/A")
        }
        
    }
}

