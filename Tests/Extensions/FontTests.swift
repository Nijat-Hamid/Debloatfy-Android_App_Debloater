//
//  FontTests.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/20/25.
//

import Testing
import SwiftUI
@testable import Debloatfy

@Suite("Font Extension Tests")
struct FontTests {
    
    @Suite("Font Weight test")
    struct FormatSizeTests{
        
        @Test
        func returnFontWeight() async throws {
            #expect(FontWeight.black.fontWeight == .black)
            #expect(FontWeight.bold.fontWeight == .bold)
            #expect(FontWeight.extraBold.fontWeight == .heavy)
            #expect(FontWeight.extraLight.fontWeight == .ultraLight)
            #expect(FontWeight.light.fontWeight == .light)
            #expect(FontWeight.medium.fontWeight == .medium)
            #expect(FontWeight.regular.fontWeight == .regular)
            #expect(FontWeight.semiBold.fontWeight == .semibold)
            #expect(FontWeight.thin.fontWeight == .thin)
        }
        
        
    }
}
