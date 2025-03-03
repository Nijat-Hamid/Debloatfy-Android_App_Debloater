//
//  DebuggingView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct DebuggingView: View {
    
    @State private var isConnected = false
    @State private var isAuthorized = false
    
    var body: some View {
        VStack(spacing:32) {
            HStack(spacing:60) {
                DebugImageView()
                DebugStepsView()
            }
            DebugIndicatorView(isConnected: isConnected, isAuthorized: isAuthorized)
            Button {
                print("Check")
            } label: {
                Text(!isConnected || !isAuthorized ? "Check Status" : " Go to Dashboard" )
            }
            .buttonStyle(ButtonStyles(type: isConnected && isAuthorized ? .success : .danger))

        }
        .modifier(PageMod())
    }
}

#Preview {
    DebuggingView()
        .modifier(PreviewMod(width: nil))
}
