//
//  LoadingSpinner.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/27/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var loadingTexts = [
        "Loading data...",
        "Fetching resources...",
        "Preparing content...",
        "Almost there...",
        "Just a moment..."
    ]
    
    @State private var currentTextIndex = 0
    
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "waveform")
                .resizable()
                .foregroundStyle(.secondary)
                .aspectRatio(contentMode: .fit)
                .frame(width: 60)
                .symbolEffect(.bounce.byLayer, options: .repeat(.periodic(delay: 0.3)))
            
            Text(loadingTexts[currentTextIndex])
                .foregroundStyle(.secondary)
                .contentTransition(.numericText())
                .font(.appHeadline)
                .fontWeight(.medium)

        }
        .onReceive(timer) { _ in
            withAnimation {
                currentTextIndex = (currentTextIndex + 1) % loadingTexts.count
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.clear)
    }
}


#Preview {
    LoadingView()
        .modifier(PreviewMod(type:.background,width: 300,padding: 24))
}
