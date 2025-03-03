//
//  ThemeIcon.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/2/25.
//

import SwiftUI

struct ThemeIconView: View {
    var scheme:ColorScheme
    @AppStorage("userTheme") private var userTheme:Theme = .dark
    
    @State private var circleOffset:CGSize = .zero
    
    private let size:CGSize
    
    init(scheme:ColorScheme,size:CGSize) {
        self.scheme = scheme
        self.size = size
        self._circleOffset = .init(initialValue: position(for: scheme))
    }
    
    private func position(for scheme: ColorScheme) -> CGSize {
        switch scheme {
        case .dark:
            return CGSize(width: size.width / 3.2, height: -size.height / 5)
        case .light:
            return CGSize(width: size.width * 2.5, height: -size.height * 2.5)
        default:
            return .zero
        }
    }
    
    
    var body: some View {
        Circle()
            .fill(userTheme.color(scheme).gradient)
            .frame(width:size.width,height:size.height)
            .mask {
                Rectangle()
                    .overlay {
                        Circle()
                            .offset(circleOffset)
                            .blendMode(.destinationOut)
                    }
            }
            .onChange(of: scheme) { _, newValue in
                withAnimation(.bouncy) {
                    circleOffset = position(for: newValue)
                }
            }
    }
    
}


#Preview {
    HStack(spacing:6){
        ThemeIconView(scheme: .dark, size: CGSize(width: 80, height: 80))
        ThemeIconView(scheme: .light, size: CGSize(width: 80, height: 80))
    }
    .modifier(PreviewMod(width: nil))
    
}
