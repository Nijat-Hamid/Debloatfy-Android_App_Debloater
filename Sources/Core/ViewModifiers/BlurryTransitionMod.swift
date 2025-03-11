//
//  BlurryTransitionMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/24/25.
//

import SwiftUI

struct BlurryTransitionMod:ViewModifier {    
    private var animationDuration:Double
    private var transitionScale:Double
    
    init(duration:Double = 0.7,scale:Double = 1.1) {
        animationDuration = duration
        transitionScale = scale
    }
    
    func body(content: Content) -> some View {
        content
            .transition(.opacity
                .combined(with: .blurReplace(.downUp))
                .combined(with: .scale(transitionScale, anchor: .center))
                .animation(.snappy(duration: animationDuration))
            )
    }
}
