//
//  AnyTransition+Extension.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/18/25.
//

import SwiftUI

extension AnyTransition {
    static var blur:AnyTransition {
        .modifier(
            active: Blur(radius: 30),
            identity: Blur(radius: 0)
        )
    }
    
    static func blur(radius:CGFloat) -> AnyTransition {
        .modifier(
            active: Blur(radius: radius),
            identity: Blur(radius: 0)
        )
    }
}

struct Blur:ViewModifier,Animatable,Hashable {
    var animatableData: CGFloat {
        get { radius }
        set { radius = newValue }
    }
    
    var radius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .blur(radius: radius)
    }
}
