//
//  DebuggingView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct DebuggingView: View {
        
    @Environment(\.auth) private var auth
    
    var body: some View {
        VStack(spacing:32) {
            HStack(spacing:60) {
                DebugImageView()
                DebugStepsView()
            }
            DebugIndicatorView(isConnected: auth.isConnected, isAuthorized: auth.isDebugEnabled)
            Button {
                Task {
                   await auth.startServer()
                }
            } label: {
                Text(auth.isAccessed ? "Access Granted" : "Check Again" )
                    .contentTransition(.numericText())
            }
            .buttonStyle(ButtonStyles(type: auth.isAccessed ? .success : .danger))
        }
    }
}

#Preview {
    DebuggingView()
        .modifier(PreviewMod(width: nil))
}
