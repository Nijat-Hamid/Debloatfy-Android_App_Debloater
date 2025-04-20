//
//  Processors.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/19/25.
//

import Foundation

struct Processors {
    
    // MARK: Main Functions
    
    static func executeADBCommand(_ command: ADB.Commands) async -> String {
        let result = await ADB.run(arguments: [command])
        switch result {
        case .success(let output, _):
            let trimmed = output.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed
        case .failure(let error, _, _):
            Log.of(.viewModel(OverviewVM.self)).warning("\(error.message)")
            return "N/A"
        }
    }
    
    static func getAppList(_ command: ADB.Commands) async -> Int {
        switch await ADB.run(arguments: [command]) {
        case .success(let output, _):
            let filteredOutput = output
                .split(separator: "\n")
                .filter { $0.starts(with: "package:") }
            return filteredOutput.count
        case .failure(let error, _, _):
            Log.of(.viewModel(OverviewVM.self)).error("\(error.message)")
            return 0
        }
    }
    
    static func toPhone(_ path:String, ) async -> TransferModel? {
        assert(!Thread.isMainThread, "This function must run not the main thread!")
        let fileName = URL(fileURLWithPath: path).lastPathComponent.removingPercentEncoding!
        let result = await ADB.run(arguments: [.copyToPhone(path.removingPercentEncoding!)])
        
        var returnData:TransferModel?
        switch result {
        case .success:
            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: path.removingPercentEncoding!)
                let isDirectory = fileAttributes[.type] as? FileAttributeType == .typeDirectory
                
                let contentSize = await ADB.run(arguments: [.getContentSize(fileName)])
                
                switch contentSize {
                case .success(let output,_):
                    let trimmedResult = output.trimmingCharacters(in: .whitespacesAndNewlines)
                    var components = trimmedResult.components(separatedBy: "\t")
                    if components.count <= 1 {
                        components = trimmedResult.components(separatedBy: " ")
                    }
                    let size = components.first ?? "N/A"
                    returnData = TransferModel(name:fileName,size: size,type: isDirectory ? .folder : .file)
                case .failure:
                    returnData = TransferModel(name:fileName,size:"N/A", type: isDirectory ? .folder : .file)
                }
                
            }catch {
                Log.of(.viewModel(TransferVM.self)).error("\(error.localizedDescription)")
            }
            
            
        case .failure(let error, _, _):
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
            returnData = nil
        }
        return returnData
    }
    
    static func toPC(_ contentName:String, copyLocation:String) async -> Bool {
        let result = await ADB.run(arguments: [.copyToPC(contentName, copyLocation)])
        
        switch result {
        case .success:
            return true
        case .failure(let error, _, _):
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
            return false
        }
    }
    
    static func removeContent(_ contentName:String, isDirectory:Bool) async -> Bool {
        let escapedContent = Utils.escapeShellCharacters(in: contentName)
        let argumentType: ADB.Commands = isDirectory ? .deleteFolder(escapedContent) : .deleteFile(escapedContent)
        let isRemoved = await ADB.run(arguments: [argumentType])
        
        switch isRemoved {
        case .success:
            return true
        case .failure(let error, _ , _):
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
            return false
        }
    }
    
    static func getPhoneData() async -> [TransferModel] {
        assert(!Thread.isMainThread, "This function must run not the main thread!")
        let storageResult = await ADB.run(arguments: [.getInternalStorage])
        
        var data:[TransferModel] = []
        switch storageResult {
        case .success(let output, _):
            let filteredResult = output.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n").filter { $0 != "Android"}
            await withTaskGroup { group in
                for content in filteredResult {
                    group.addTask {
                        let escapedContent = Utils.escapeShellCharacters(in: content)
                        
                        let result = await ADB.run(arguments: [.getContentSize(escapedContent)])
                        
                        switch result {
                        case .success(let output, _):
                            
                            if !output.contains("/system/bin/sh") {
                                let trimmedResult = output.trimmingCharacters(in: .whitespacesAndNewlines)
                                var components = trimmedResult.components(separatedBy: "\t")
                                if components.count <= 1 {
                                    components = trimmedResult.components(separatedBy: " ")
                                }
                                let size = components.first ?? "N/A"
                                
                                let typeResult = await ADB.run(arguments: [.detectType(escapedContent)])
                                
                                switch typeResult {
                                case .success(let output, _):
                                    let isDirectory = output.trimmingCharacters(in: .whitespacesAndNewlines) == "directory"
                                    return (content, size, isDirectory)
                                case .failure:
                                    return (content, size, false)
                                }
                            } else {
                                return (content, "N/A", false)
                            }
                        case .failure:
                            return (content, "N/A", false)
                        }
                    }
                }
                
                for await (content, size, isDirectory) in group {
                    data.append(.init(name:content, size: size ,type: isDirectory ? .folder : .file))
                }
            }
            data.sort { contentOne, contentTwo in
                if contentOne.type != contentTwo.type {
                    return contentOne.type == .folder
                }
                
                let size1 = Double(contentOne.size) ?? 0.0
                let size2 = Double(contentTwo.size) ?? 0.0
                return size1 > size2
            }
            
        case .failure(let error, _, _):
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
        }
        
        return data
    }
    
    static func createDefaultFolder() async {
        do {
            let targetURL = FileKit.defaultTransferDir
            
            guard !FileManager.default.fileExists(atPath: targetURL.path()) else {return}
            
            try FileManager.default.createDirectory(at: targetURL, withIntermediateDirectories: true)
            
        } catch {
            Log.of(.viewModel(TransferVM.self)).error("An error occurred while creating the default folder:\(error.localizedDescription)")
        }
    }
    
    static func restoreSingleApp(_ packageName:String) async -> Bool {
        if FileKit.existsApkDir(packageName) {
            do {
                let apkDir = FileKit.returnApkDir(packageName).path()
                let apkContents = try FileManager.default.contentsOfDirectory(atPath: apkDir)
                let apkSplitBundle = apkContents.filter { $0.hasSuffix(".apk")}.map { "\(apkDir)/\($0)" }.joined(separator: " ")
                let result = await ADB.run(arguments: [.restoreApk(apkSplitBundle)])
                
                switch result {
                case .success:
                    return true
                case .failure(let error, _ , _):
                    Log.of(.viewModel(RestoreVM.self)).error("\(error.message)")
                    return false
                }
                
            } catch {
                Log.of(.viewModel(RestoreVM.self)).error("\(packageName):\(error.localizedDescription)")
            }
        }
        return false
    }
    
    static func restoreMultipleApp(_ packages:Set<String>) async -> [(package: String, isSuccess: Bool)] {
        var results: [(String, Bool)] = []
        await withTaskGroup { group in
            for package in packages {
                if FileKit.existsApkDir(package) {
                    do {
                        let apkDir = FileKit.returnApkDir(package).path()
                        let apkContents = try FileManager.default.contentsOfDirectory(atPath: apkDir)
                        let apkSplitBundle = apkContents.filter { $0.hasSuffix(".apk")}.map { "\(apkDir)/\($0)" }.joined(separator: " ")
                        group.addTask {
                            let result = await ADB.run(arguments: [.restoreApk(apkSplitBundle)])
                            switch result {
                            case .success:
                                return (package, true)
                            case .failure(let error, _,_):
                                Log.of(.viewModel(RestoreVM.self)).error("\(error.message)")
                                return (package, false)
                            }
                        }
                    } catch {
                        Log.of(.viewModel(RestoreVM.self)).error("Error reading apk directory for \(package):\(error.localizedDescription)")
                    }
                }
            }
            
            for await (package,isSuccess) in group {
                if isSuccess {
                    results.append((package, isSuccess))
                }
            }
        }
        
        return results
    }
    
    static func deleteRestoredApps(_ packages:Set<String>) async -> [(package: String, isSuccess: Bool)] {
        var results: [(String, Bool)] = []
        
        do {
            guard FileKit.existsBackupDir,
                  FileKit.existsBackupJson
            else { return results }
            
            let existingData = try Data(contentsOf: FileKit.backupJson)
            let decoder = JSONDecoder()
            var jsonDict = try decoder.decode([String: PackageInfo].self, from: existingData)
            
            await withThrowingTaskGroup { group in
                for packageName in packages {
                    group.addTask {
                        do {
                            if FileKit.existsApkDir(packageName) {
                                try FileManager.default.removeItem(at: FileKit.returnApkDir(packageName))
                                return (packageName, true)
                            } else {
                                return (packageName, false)
                            }
                        } catch {
                            return (packageName, false)
                        }
                    }
                }
                
                do {
                    for try await (packageName, isSuccess) in group {
                        if isSuccess {
                            results.append((packageName, isSuccess))
                            jsonDict.removeValue(forKey: packageName)
                        }
                    }
                } catch {
                    Log.of(.viewModel(RestoreVM.self)).error("An error occurred during bulk remove: \(error.localizedDescription)")
                }
            }
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let updatedData = try encoder.encode(jsonDict)
            try updatedData.write(to: FileKit.backupJson)
            
        } catch {
            Log.of(.viewModel(RestoreVM.self)).error("An error occurred during bulk remove: \(error.localizedDescription)")
        }
        
        return results
    }
    
    static func deleteRestoredApp(_ packageName:String) async -> Bool {
        do {
            guard FileKit.existsBackupDir,
                  FileKit.existsBackupJson
            else { return false }
            
            let existingData = try Data(contentsOf: FileKit.backupJson)
            let decoder = JSONDecoder()
            var jsonDict = try decoder.decode([String: PackageInfo].self, from: existingData)
            
          
                if FileKit.existsApkDir(packageName) {
                    try FileManager.default.removeItem(at: FileKit.returnApkDir(packageName))
                }
    
                jsonDict.removeValue(forKey: packageName)
            
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let updatedData = try encoder.encode(jsonDict)
                try updatedData.write(to: FileKit.backupJson)
                
                return true
        } catch {
            Log.of(.viewModel(RestoreVM.self)).error("An error occurred during tasks: \(error.localizedDescription)")
            return false
        }
    }
    
    static func getRestoredApps() async -> [AppListModel] {
        var data:[AppListModel] = []
        do {
            guard FileKit.existsBackupDir,
                  FileKit.existsBackupJson
            else {  return data }
            
            let existingData = try Data(contentsOf: FileKit.backupJson)
            let decoder = JSONDecoder()
            let jsonDict = try decoder.decode([String: PackageInfo].self, from: existingData)
            
            for (packageName, packageInfo) in jsonDict {
                if FileKit.existsApkDir(packageName) {
                    data.append(.init(package: packageName, type: packageInfo.type == "System" ? .system : .user, size: packageInfo.totalSize))
                }
            }
            data.sort { app1, app2 in
                let size1 = Double(app1.size) ?? 0.0
                let size2 = Double(app2.size) ?? 0.0
                return size1 > size2
            }
            
        } catch {
            Log.of(.viewModel(RestoreVM.self)).error("Error during backup process: \(error.localizedDescription)")
        }
        
        return data
    }
    
    static func deleteSingleApp(_ packageName:String) async -> Bool {
        let result = await ADB.run(arguments: [.uninstallApk(packageName)])
        switch result {
        case .success:
            return true
        case .failure(let error,_,_):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
            return false
        }
    }
    
    static func deleteMultipleApps(_ packages:Set<String>) async -> [(package: String, isSuccess: Bool)] {
        
        var result:[(package: String, isSuccess: Bool)] = []
        await withTaskGroup { group in
            for package in packages {
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
                    result.append((package,isSuccess))

                }
            }
        }
        
        return result
    }
    
    static func getDeviceApps(type: ListAppType, arguments: ADB.Commands) async -> [AppListModel] {
        let appList = await ADB.run(arguments: [arguments])
        
        var result:[AppListModel] = []
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
                        await getPackageSize(packageName: packageName)
                    }
                }
                
                for await (packageName, size) in group {
                    result.append(.init(package: packageName, type: type, size: size))
                }
            }
        case .failure(let error, _, _):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
        }
        return result
    }

    static func bulkBackupApps(_ packages:Set<String>, deviceAppList: [AppListModel] ) async -> [String] {
        var data:[String] = []
        
        do {
            if !FileKit.existsBackupDir {
                try FileKit.createBackupDirIfNeeded()
            }
            
           
            var allBackupInfo = loadExistingBackupInfo(from: FileKit.backupJson)
            
            let results = await withTaskGroup { group in
                var packageResults = [(String, PackageInfo)]()
                
                for package in packages {
                    if let choosenApk = deviceAppList.filter({ $0.package == package}).first, choosenApk.type != .system {
                        group.addTask {
                            return await processPackage(package, backupsDirectory: FileKit.backupDir, appList: deviceAppList)
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
                data.append(package)
            }
            
            try saveBackupInfo(allBackupInfo, to: FileKit.backupJson)
            
        } catch {
            Log.of(.viewModel(DebloatVM.self)).error("Error during backup process: \(error.localizedDescription)")
        }
        
        return data
    }
    
    static func singleBackupApp(_ packageName:String, deviceAppList: [AppListModel]) async -> Bool {
        do {
            if !FileKit.existsBackupDir {
                try FileKit.createBackupDirIfNeeded()
            }
            
            var allBackupInfo = loadExistingBackupInfo(from: FileKit.backupJson)
            
            let resultOfProcessing = await processPackage(packageName, backupsDirectory: FileKit.backupDir, appList: deviceAppList)
            
            allBackupInfo[packageName] = resultOfProcessing?.1
            
            try saveBackupInfo(allBackupInfo, to: FileKit.backupJson)

            return true
        } catch {
            Log.of(.viewModel(DebloatVM.self)).error("Error during backup process: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: Helper functions to main functions
    private static func getPackageSize(packageName: String) async -> (String, String) {
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
    
    private static func loadExistingBackupInfo(from url: URL) -> [String: PackageInfo] {
        guard FileManager.default.fileExists(atPath: url.path) else { return [:] }
        
        do {
            let existingData = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode([String: PackageInfo].self, from: existingData)
        } catch {
            Log.of(.viewModel(DebloatVM.self)).error("Warning: Could not read existing backup info: \(error.localizedDescription)")
            return [:]
        }
    }
    
    private static func processPackage(_ package: String, backupsDirectory: URL, appList:[AppListModel]) async -> (String, PackageInfo)? {
        
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
                if !FileManager.default.fileExists(atPath: packageDirectory.path) {
                    try FileManager.default.createDirectory(at: packageDirectory, withIntermediateDirectories: true)
                }
                
                var appType = ""
                var totalSize = ""
                
                if let appInfo = appList.first(where: { $0.package == package }) {
                    appType = appInfo.type.rawValue
                    totalSize = appInfo.size
                }
                
                let apksInfo = try await pullApksInParallel(filteredApkPaths: filteredApkPaths, packageDirectory: packageDirectory)
                let packageInfo = PackageInfo(type: appType, totalSize: totalSize, apks: apksInfo)
                
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
    
    private static func pullApksInParallel(filteredApkPaths: [String], packageDirectory: URL) async throws -> [SingleApkModel] {
        return await withTaskGroup { group in
            var results = [SingleApkModel]()
            
            for path in filteredApkPaths {
                group.addTask {
                    return await pullSingleApk(path: path, packageDirectory: packageDirectory)
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
    
    private static func pullSingleApk(path: String, packageDirectory: URL) async -> SingleApkModel? {
        guard let lastSlashIndex = path.lastIndex(of: "/") else { return nil }
        
        let baseDir = String(path[..<lastSlashIndex])
        let fileName = URL(fileURLWithPath: path).lastPathComponent
        let destinationURL = packageDirectory.appendingPathComponent(fileName)
        
        
        let result = await ADB.run(arguments: [.backupApk(path, destinationURL.path)])
        switch result {
        case .success:
            return SingleApkModel(fileName: fileName, originalPath: baseDir)
        case .failure(let error,_,_):
            Log.of(.viewModel(DebloatVM.self)).error("\(error.message)")
            return nil
        }
    }
    
    private static func saveBackupInfo(_ info: [String: PackageInfo], to url: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let jsonData = try encoder.encode(info)
        try jsonData.write(to: url)
    }
}

