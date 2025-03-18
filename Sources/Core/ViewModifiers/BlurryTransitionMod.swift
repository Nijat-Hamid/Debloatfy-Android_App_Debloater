//
//  BlurryTransitionMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/24/25.
//

import SwiftUI

struct BlurryTransitionMod:ViewModifier {    
    private var animationDuration:Double
    
    init(duration:Double = 0.9) {
        animationDuration = duration
    }
    
    func body(content: Content) -> some View {
        content
            .transition(.opacity
                .animation(.snappy(duration: animationDuration))
            )
    }
}
