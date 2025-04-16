//
//  TransferVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/10/25.
//
import SwiftUI

@Observable
final class TransferVM {
    private let auth: Auth
    private let dbService: DBService
    
    init(auth:Auth = Auth.shared, dbService:DBService = .shared) {
        self.auth = auth
        self.dbService = dbService
    }
    
    private(set) var isLoading:Bool = false
    private(set) var storageContent:[TransferModel] = []
    private(set) var isProceeding:Bool = false
    private(set) var isCopying:Bool = false
    private(set) var isDeleting:Bool = false
    private(set) var activeTask:Task<Void,Never>?
    var showActionSheet:Bool = false
        
    
    func setActiveTask(action: @escaping () async -> ()) {
        
        activeTask?.cancel()
        
        
        let task = Task {
            await action()
            activeTask = nil
        }
        
        activeTask = task
        
    }
    
    func cancelActiveTask() async {
        activeTask?.cancel()
        activeTask = nil
        
        defer {
            isProceeding = false
            isCopying = false
            showActionSheet = false
        }
        
        let result = await ADB.run(arguments: [.reconnect])
        switch result {
        case .success:
            await getInternalStorage()
        case .failure(let error, _, _):
            Log.of(.viewModel(TransferVM.self)).error("ADB can't killed:\(error.message)")
        }
        
        
    }
    
    func copyToPhone(_ path:String) async {
        isProceeding = true
        isCopying = true
        defer {
            isProceeding = false
            isCopying = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        showActionSheet = true
        
        let fileName = URL(fileURLWithPath: path).lastPathComponent.removingPercentEncoding!
        
        let result = await ADB.run(arguments: [.copyToPhone(path.removingPercentEncoding!)])
        
        
        switch result {
        case .success:
            do {
                let fileAttributes = try FileKit.manager.attributesOfItem(atPath: path.removingPercentEncoding!)
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
                    
                    storageContent.append(.init(name:fileName,size: size,type: isDirectory ? .folder : .file))
                    
                    try await dbService.save(.init(name: fileName, type: .transfer,from: "PC", to: "Phone"))
                case .failure:
                    storageContent.append(.init(name:fileName,size:"N/A", type: isDirectory ? .folder : .file))
                }
                
            }catch {
                showActionSheet = false
                Log.of(.viewModel(TransferVM.self)).error("\(error.localizedDescription)")
            }
            
            
        case .failure(let error, _, _):
            showActionSheet = false
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
        }
    }
    
    func copyToPC(_ contentName:String, copyLocation:String) async {
        isProceeding = true
        isCopying = true
        
        defer {
            isProceeding = false
            isCopying = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        showActionSheet = true
        
        let result = await ADB.run(arguments: [.copyToPC(contentName, copyLocation)])
        
        switch result {
        case .success:
            do {
                try await dbService.save(.init(name: contentName, type: .transfer,from: "Phone", to: "PC"))
            }catch{
                Log.of(.viewModel(TransferVM.self)).error("\(error.localizedDescription)")
            }
        case .failure(let error, _, _):
            showActionSheet = false
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
        }
    }
    
    func deleteContent(_ contentName:String, isDirectory:Bool) async {
        isProceeding = true
        isDeleting = true
        defer {
            isProceeding = false
            isDeleting = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        showActionSheet = true
        
        let escapedContent = Utils.escapeShellCharacters(in: contentName)
        
        let argumentType: ADB.Commands = isDirectory ? .deleteFolder(escapedContent) : .deleteFile(escapedContent)
        
        let isRemoved = await ADB.run(arguments: [argumentType])
        
        switch isRemoved {
        case .success:
            do {
                let contentType: TransferModelType = isDirectory ? .folder : .file
                storageContent.removeAll(where: { $0.name == contentName && $0.type == contentType })
                try await dbService.save(.init(name: contentName, type: .fileRemove))
            }catch{
                Log.of(.viewModel(TransferVM.self)).error("\(error.localizedDescription)")
            }
        case .failure(let error, _ , _):
            Log.of(.viewModel(TransferVM.self)).error("\(error.message)")
        }
        
    }
    
    func getInternalStorage() async {
        isLoading = true
        storageContent = []
        
        defer {
            isLoading = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let storageResult = await ADB.run(arguments: [.getInternalStorage])
        
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
                    storageContent.append(.init(name:content, size: size ,type: isDirectory ? .folder : .file))
                }
            }
            
            storageContent.sort { contentOne, contentTwo in
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
        
    }
    
    func createDefaultDir() async {
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        do {
            let targetURL = FileKit.defaultTransferDir
            
            guard !FileKit.manager.fileExists(atPath: targetURL.path()) else {return}
            
            try FileKit.manager.createDirectory(at: targetURL, withIntermediateDirectories: true)
            
        } catch {
            Log.of(.viewModel(TransferVM.self)).error("An error occurred while creating the default folder:\(error.localizedDescription)")
        }
    }
}

