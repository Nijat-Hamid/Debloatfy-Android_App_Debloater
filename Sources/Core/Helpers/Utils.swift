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
    
    static let bundleID = bundle.bundleIdentifier ?? unknown
    
    static let appName = bundle.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
        bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ?? unknown
    
    
    static let productName = bundle.object(forInfoDictionaryKey: "CFBundleName") as? String ??
        bundle.object(forInfoDictionaryKey: "CFBundleExecutable") as? String ?? unknown
    
    
    static let appVersion = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? unknown
    
    static let buildNumber = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? unknown
    
    static let appCategory = bundle.object(forInfoDictionaryKey: "LSApplicationCategoryType") as? String ?? unknown
    
    static let minOSVersion = bundle.object(forInfoDictionaryKey: "LSMinimumSystemVersion") as? String ?? unknown
    
    static let copyright = bundle.object(forInfoDictionaryKey: "NSHumanReadableCopyright") as? String ?? unknown
    
    static let author = bundle.object(forInfoDictionaryKey: "Author") as? String ?? unknown
    
    static func getInfoPlistValue(forKey key: String) -> String {
        return bundle.object(forInfoDictionaryKey: key) as? String ?? unknown
    }
        
    static func formatSize(_ sizeInMB: String) -> String {
        if let sizeValue = Double(sizeInMB) {
            if sizeValue >= 1000 {
                let sizeInGB = sizeValue / 1000.0
                return String(format: "%.2f GB", sizeInGB)
            } else if sizeValue < 1 {
                return "1 MB"
            } else {
                return "\(sizeInMB) MB"
            }
        }
        return "N/A"
    }
    
    static func escapeShellCharacters(in string: String) -> String {
        let pattern = "[\\s\\\\\"'`$&()|<>\\[\\]{}?*#~@!%^=;,]"
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex?.stringByReplacingMatches(
            in: string,
            options: [],
            range: range,
            withTemplate: "\\\\$0"
        ) ?? string
    }
    
    static func dateFormatter(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM dd, yyyy | HH:mm:ss"
        return formatter.string(from: date)
    }
}
