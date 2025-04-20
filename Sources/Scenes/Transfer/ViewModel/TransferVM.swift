//
//  TransferVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/10/25.
//
import SwiftUI

@MainActor @Observable
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
        showActionSheet = false
        
        let result = await ADB.run(arguments: [.reconnect])
        switch result {
        case .success: break
        case .failure(let error, _, _):
            Log.of(.viewModel(TransferVM.self)).error("ADB can't killed:\(error.message)")
        }
        
        isProceeding = false
        isCopying = false
    }
    
    func copyToPhone(_ path:String) async {
        isProceeding = true
        isCopying = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        showActionSheet = true
        
        if let result = await Processors.toPhone(path) {
            storageContent.append(result)
            try? await dbService.save(.init(name: result.name, type: .transfer,from: "PC", to: "Phone"))
        } else {
            showActionSheet = false
        }
        
        isProceeding = false
        isCopying = false
    }
    
    func copyToPC(_ contentName:String, copyLocation:String) async {
        isProceeding = true
        isCopying = true
    
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        showActionSheet = true
        
        if await Processors.toPC(contentName, copyLocation: copyLocation) {
            try? await dbService.save(.init(name: contentName, type: .transfer,from: "Phone", to: "PC"))
        } else {
            showActionSheet = false
        }
        
        isProceeding = false
        isCopying = false
    }
    
    func deleteContent(_ contentName:String, isDirectory:Bool) async {
        isProceeding = true
        isDeleting = true
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        showActionSheet = true
        
        if await Processors.removeContent(contentName, isDirectory: isDirectory) {
            storageContent.removeAll(where: { $0.name == contentName && $0.type == (isDirectory ? .folder : .file) })
            try? await dbService.save(.init(name: contentName, type: .fileRemove))
        }
        
        isProceeding = false
        isDeleting = false
    }
    
    func getInternalStorage() async {
        isLoading = true
        storageContent = []
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        let result = await Processors.getPhoneData()
        
        if !result.isEmpty {
            storageContent = result
        }
    
        isLoading = false
    }
    
    func createDefaultDir() async {
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        await Processors.createDefaultFolder()
    }
}

