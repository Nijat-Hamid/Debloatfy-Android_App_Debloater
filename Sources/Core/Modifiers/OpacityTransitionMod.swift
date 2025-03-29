//
//  BlurryTransitionMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/24/25.
//

import SwiftUI

struct OpacityTransitionMod:ViewModifier {
    private var animationDuration:Double
    private var delay: TimeInterval
    
    init(duration:Double = 0.9,delay:TimeInterval = 0) {
        animationDuration = duration
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .transition(
                .opacity
                    .animation(.snappy(duration: animationDuration).delay(delay))
            )
    }
}
