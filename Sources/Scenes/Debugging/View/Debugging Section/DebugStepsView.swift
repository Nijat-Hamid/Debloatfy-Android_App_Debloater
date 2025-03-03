//
//  DebugStepsView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/3/25.
//

import SwiftUI

struct DebugStepsView: View {
    var body: some View {
        VStack(alignment: .leading,spacing: 12) {
            Text("Steps").bold()
            Text("1. Go to ")
            + Text("'Settings > About Phone'").bold()
            
            Text("2. Tap ")
            + Text("Build number ").bold()
            + Text("7 times to enable Developer options")
            
            Text("3. Go to ")
            + Text("Settings > Developer options > Turn on USB debugging").bold()
            
            
            Text("4. Tap OK on the ")
            + Text("Allow USB debugging").bold()
            + Text("pop-up dialog.")
        }
        .font(.appHeadline)
        .fontWeight(.medium)
    }
}

#Preview {
    DebugStepsView()
        .modifier(PreviewMod(width: nil))
}
