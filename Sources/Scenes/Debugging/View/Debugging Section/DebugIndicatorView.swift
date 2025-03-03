//
//  DebugIndicatorView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/3/25.
//

import SwiftUI

struct DebugIndicatorView: View {
    
    var isConnected:Bool
    var isAuthorized:Bool
    
    var body: some View {
        VStack(alignment:.leading,spacing: 12) {
            
            Label {
                Text(isConnected ? "USB debugging enabled" : "Turn on USB debugging")
                    .contentTransition(.numericText())
            } icon: {
                Image(systemName: isConnected ? "lock.open":"lock")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(isConnected ? .greenish : .reddish , .foregroundPrimary)
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
            }
            .font(.appTitle3)
            .fontWeight(.semibold)
            
            
            Label {
                Text(isAuthorized ? "Access Granted" : "Access Denied")
                    .contentTransition(.numericText())
            } icon: {
                Image(systemName: isAuthorized ? "lock.open":"lock")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(isAuthorized ? .greenish : .reddish , .foregroundPrimary)
                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp.byLayer), options: .nonRepeating))
            }
            .font(.appTitle3)
            .fontWeight(.semibold)

        }
    }
}

#Preview {
    DebugIndicatorView(isConnected: true, isAuthorized: false)
        .modifier(PreviewMod(width: nil))
}
