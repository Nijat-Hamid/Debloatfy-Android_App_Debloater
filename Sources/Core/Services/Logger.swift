//
//  Logger.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/2/25.
//

import SwiftUI
import SwiftData

@MainActor
final class Logger {
    
    static let shared = Logger()
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    private init(){
        let storeUrl = URL.documentsDirectory
        let configuration = ModelConfiguration("Logs",url: storeUrl)
        
        do {
            self.modelContainer = try ModelContainer(for: LoggerModel.self, configurations: configuration)
            self.modelContext = modelContainer.mainContext
            self.modelContext.autosaveEnabled = true
        } catch {
            print("Logger initialization error: \(error.localizedDescription)")
            fatalError("Failed to initialize Logger: \(error)")
        }
    }
    
    func fetchLogs() -> [LoggerModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<LoggerModel>())
        } catch {
            print("Error fetching logs: \(error.localizedDescription)")
            return []
        }
    }
    
    func addLog(_ log:LoggerModel) {
        modelContext.insert(log)
        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error saving log: \(error.localizedDescription)")
//        }
    }
    
    func clearLogs() {
        let logs = fetchLogs()
        
        logs.forEach { log in
            modelContext.delete(log)
        }
        
//        do {
//            try modelContext.save()
//        } catch {
//            print("Error clearing logs: \(error.localizedDescription)")
//        }
    }
}
