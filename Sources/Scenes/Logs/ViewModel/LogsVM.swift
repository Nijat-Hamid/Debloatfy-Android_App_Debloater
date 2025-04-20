//
//  LogsVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/2/25.
//
import SwiftUI

@MainActor @Observable
final class LogsVM {
    private let auth: Auth
    private let dbService: DBService

    private(set) var isLoading:Bool = false
    private(set) var isProceeding:Bool = false
    private(set) var logList:[DBModel] = []
    
    init(auth:Auth = Auth.shared,dbService:DBService = .shared ) {
        self.auth = auth
        self.dbService = dbService
    }
    
    func fetchLogs() async {
        isLoading = true
        logList = []
        
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        do{
            logList = try await dbService.get()
        }catch {
            Log.of(.viewModel(LogsVM.self)).error("Error occuried during fetchLogs:\(error)")
        }
        
        isLoading = false
    }
    
    func removeLogs() async {
        isProceeding = true
    
        await auth.startServer()
        
        guard auth.isAccessed else { return }
        
        do{
            try await dbService.deleteAll()
            logList = []
        }catch{
            Log.of(.viewModel(LogsVM.self)).error("Error occuried during deleting logs:\(error)")
        }
        
        isProceeding = false
    }
}
