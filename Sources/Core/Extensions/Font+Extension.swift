//
//  Font+Extension.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/13/25.
//

import SwiftUI

extension Font {
    static private var fontCache: [String: Font] = [:]
    
    static private func font(type: FontType, weight: FontWeight, style: Font.TextStyle) -> Font {
        let key = "\(type.rawValue)-\(weight.rawValue)-\(style)"
        if let cachedFont = fontCache[key] {
            return cachedFont
        }
        
        let font = Font.custom(type.rawValue, size: 16,relativeTo: style)
            .weight(weight.fontWeight)
        fontCache[key] = font
        return font
    }
    
    static private func makeFont(weight: FontWeight, style: Font.TextStyle) -> Font {
        font(type: .nunito, weight: weight, style: style)
    }
    
    static let appLargeTitle = makeFont(weight: .bold, style: .largeTitle)
    
    static let appTitle = makeFont(weight: .bold, style: .title)
    
    static let appTitle2 = makeFont(weight: .bold, style: .title2)
    
    static let appTitle3 = makeFont(weight: .bold, style: .title3)
    
    static let appHeadline = makeFont(weight: .bold, style: .headline)
    
    static let appSubHeadline = makeFont(weight: .regular, style: .subheadline)
    
    static let appFootnote = makeFont(weight: .regular, style: .footnote)
    
    static let appBody = makeFont(weight: .regular, style: .body)
    
    static let appCallout = makeFont(weight: .regular, style: .callout)
    
    static let appCaption = makeFont(weight: .regular, style: .caption)
    
    static let appCaption2 = makeFont(weight: .light, style: .caption2)
}


enum FontType:String{
    case nunito = "Nunito"
}

enum FontWeight:String{
    case extraLight, light, thin, regular, medium, semiBold, bold, extraBold, black
    
    var fontWeight: Font.Weight {
        switch self {
        case .extraLight: return .ultraLight
        case .light: return .light
        case .thin: return .thin
        case .regular: return .regular
        case .medium: return .medium
        case .semiBold: return .semibold
        case .bold: return .bold
        case .extraBold: return .heavy
        case .black: return .black
        }
    }
}
