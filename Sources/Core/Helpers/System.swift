//
//  System.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/28/25.
//

import AppKit

struct System {
    static func configureWindow(_ window: NSWindow) {
        window.styleMask.remove(.fullScreen)
        window.styleMask.remove(.resizable)
        
        window.collectionBehavior.remove(.fullScreenPrimary)
        window.collectionBehavior.insert(.fullScreenNone)
        
        if let button = window.standardWindowButton(.zoomButton) {
            button.isEnabled = false
        }
    }
}
