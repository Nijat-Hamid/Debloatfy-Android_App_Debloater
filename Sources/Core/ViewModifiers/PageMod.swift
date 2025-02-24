//
//  PageMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct PageMod:ViewModifier {
    
    private let hideToolbar:Bool
    
    init(hideToolbar:Bool = false) {
        self.hideToolbar = hideToolbar
    }
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar(hideToolbar ? .hidden : .automatic, for: .automatic)
            .toolbarBackground(hideToolbar ? .hidden : .automatic, for: .automatic)
    }
}
