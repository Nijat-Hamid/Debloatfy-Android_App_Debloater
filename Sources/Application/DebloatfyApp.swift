//
//  DebloatfyApp.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/12/25.
//

import SwiftUI
import Foundation


@main
struct DebloatfyApp: App {
    var body: some Scene {
        WindowGroup {
            LayoutView()
                .modifier(AppMod())
                .modifier(ColorSchemeTransition())
                .modifier(RemoveFocusOnTapModifier())
                .onAppear {
                    guard let adbPath = Bundle.main.path(forResource: "adb", ofType: nil) else {
                        print("❌ ADB binary bulunamadı!")
                        return
                    }
                    
                    print("✅ ADB Path: \(adbPath)") // Path'i kontrol edin
                    
                    let task = Process()
                    task.launchPath = adbPath
                    task.arguments = ["start-server"]
                    
                    let pipe = Pipe()
                    task.standardOutput = pipe
                    task.standardError = pipe
                    
                    do {
                        try task.run()
                        
                        let data = pipe.fileHandleForReading.readDataToEndOfFile()
                        if let output = String(data: data, encoding: .utf8) {
                            print("📦 ADB Output: \(output)")
                        } else {
                            print("❌ No output data")
                        }
                    } catch {
                        print("❌ Error running ADB command: \(error.localizedDescription)")
                    }
                }
        }
        .windowToolbarStyle(.unifiedCompact)
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1000, height: 500)
        .windowResizability(.contentSize)
    }
}
