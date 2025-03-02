//
//  Constans.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/13/25.
//
import SwiftUI

enum Theme:String,CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    func color(_ scheme: ColorScheme) -> Color {
        switch self {
        case .light:
            return .orangeish
        case .dark:
            return .pinkish
        }
    }
    
    
    var colorScheme:ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
    
    var schemeTitle:String {
        switch self {
        case .light:
            return "Light Mode"
        case .dark:
            return "Dark Mode"
        }
    }
}

