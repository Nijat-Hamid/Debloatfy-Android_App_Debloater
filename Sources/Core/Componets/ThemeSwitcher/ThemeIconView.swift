//
//  ThemeIconView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/22/25.
//

import SwiftUI

struct ThemeIconView: View {
    var isDark: Bool
    @State private var circleOffset: CGSize
    @State private var showRays: Bool
    let size: CGSize
    
    // Computed properties for better maintenance and reusability
    private let rayCount =  10
    private var rayWidth: CGFloat { size.width * 0.125 }
    private var rayHeight: CGFloat { size.height * 0.2 }
    private var rayOffset: CGFloat { size.height * -0.5 }
    
    private var circleSize: CGSize {
        isDark ? size : CGSize(
            width: size.width * 0.70,  // Sun is 70% of moon size
            height: size.height * 0.70
        )
    }
    
    private var darkModeOffset: CGSize {
        CGSize(
            width: size.width * 0.4,
            height: size.height * -0.15625
        )
    }
    
    init(isDark: Bool, size: CGSize = .init(width: 16, height: 16)) {
        self.size = size
        self.isDark = isDark
        self._showRays = .init(initialValue: !isDark)
        self._circleOffset = .init(initialValue: CGSize(
            width: isDark ? size.width * 0.4 : size.width,
            height: isDark ? size.height * -0.15625 : -size.height
        ))
    }
    
    var body: some View {
        ZStack {
            // Sun rays
            if !isDark {
                ForEach(0..<rayCount, id: \.self) { index in
                    Rectangle()
                        .fill(Color.orangeish.gradient)
                        .frame(width: rayWidth, height: rayHeight)
                        .clipShape(.rect(cornerRadius: rayWidth * 5))
                        .offset(y: rayOffset)
                        .rotationEffect(.degrees(Double(index) * (360.0 / Double(rayCount))))
                        .scaleEffect(showRays ? 1 : 0)
                        .opacity(showRays ? 1 : 0)
                        .animation(
                            .spring(duration: 0.3)
                            .delay(Double(index) * 0.05),
                            value: showRays
                        )
                }
            }
            
            // Main circle (sun/moon)
            Circle()
                .fill(isDark ? Color.pinkish.gradient : Color.orangeish.gradient)
                .frame(width: circleSize.width, height: circleSize.height)
                .mask {
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(circleOffset)
                                .blendMode(.destinationOut)
                        }
                }
                .onChange(of: isDark) { _, _ in
                    withAnimation(.snappy) {
                        circleOffset = isDark ? darkModeOffset : CGSize(
                            width: size.width,
                            height: -size.height
                        )
                    }
                    if !isDark {
                        showRays = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            showRays = true
                        }
                    }
                }
        }
        .offset(x: isDark ? 0 : 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        ThemeIconView(isDark: true)
            .frame(width: 100, height: 100)
    }
}
