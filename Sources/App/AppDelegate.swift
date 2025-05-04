//
//  AppDelegate.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 5/3/25.
//
import AppKit

class AppDelegate: NSObject,NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        Task {
            await ADB.run(arguments: [.kill])
        }
    }
}
