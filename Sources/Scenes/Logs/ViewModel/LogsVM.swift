//
//  LogsVM.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/2/25.
//
import SwiftUI

@Observable
@MainActor
final class LogsVM {
    
    private let auth: Auth
    private let logger: Logger
    
    private(set) var isLoading:Bool = false
    private(set) var logList:[LoggerModel] = []
    
    init(auth:Auth = Auth.shared, logger:Logger) {
        self.auth = auth
        self.logger = logger
        
        logList = logger.fetchLogs()
    }
    
    
    
    func getLogs() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        await auth.startServer()
        
        guard auth.isAccessed else {
            print("Access not granted, returning early")
            return
        }
    }
    
    
}
