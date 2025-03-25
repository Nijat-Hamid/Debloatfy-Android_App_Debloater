//
//  Utils.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/2/25.
//

import Foundation

struct Utils {
    
    private static let bundle = Bundle.main
    private static let unknown = "N/A"
    
    static var bundleID: String {
        bundle.bundleIdentifier ?? unknown
    }
    
    static var appName: String {
        bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ??
        unknown
    }
    
    static var productName: String {
        bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ??
        bundle.object(forInfoDictionaryKey: "CFBundleExecutable") as? String ?? "N/A"
    }
    
    static var appVersion: String {
        bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? unknown
    }
    
    static var buildNumber: String {
        bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? unknown
    }
    
    static var appCategory:String {
        bundle.object(forInfoDictionaryKey: "LSApplicationCategoryType") as? String ?? unknown
    }
    
    static var minOSVersion: String {
        bundle.object(forInfoDictionaryKey: "LSMinimumSystemVersion") as? String ?? unknown
    }
    
    static var copyright: String {
        return bundle.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? unknown
    }
    
    static var author: String {
        return bundle.object(forInfoDictionaryKey: "Author") as? String ?? unknown
    }
    
    static func getInfoPlistValue(forKey key: String) -> String {
        return bundle.object(forInfoDictionaryKey: key) as? String ?? unknown
    }
    
    
    static func getDownloadLocation () -> URL {
        guard let downloadsURL = FileManager.default.urls(for: .userDirectory, in: .localDomainMask).first else {
            return FileManager.default.homeDirectoryForCurrentUser
        }
        let userName = NSUserName()
        let downloadsFolder = downloadsURL.appending(path: userName).appending(path: "Downloads")
        return downloadsFolder
    }
}
