//
//  InfoPurposeView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/3/25.
//

import SwiftUI

struct InfoPurposeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text("Purpose:")
                    .fontWeight(.semibold)
                Spacer()
            } icon: {
                Image(systemName: "questionmark.app")
                    .resizable()
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.foregroundPrimary, .brand)
                    .frame(width: 18,height: 18)
            }
            .font(.appTitle3)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("This app was developed to address the common frustration of bloatware on Android devices. Initially created for personal use, it provides a simple macOS interface to remove unwanted pre-installed applications from Android phones and tablets without requiring root access.")
                
                Text("The app also includes functionality to backup Android device files to macOS through ADB (Android Debug Bridge), making it a comprehensive tool for Android device management on Mac systems.")
                
                Text("After developing this solution and surveying the market, I discovered a lack of similar tools specifically designed for macOS users. While Windows has several options for bloatware removal and device management, macOS users have limited alternatives. This gap in the ecosystem motivated me to release this project as open-source software, allowing the broader community of Mac-using Android owners to benefit from these tools.")
            }
            .font(.appHeadline)
            .fontWeight(.medium)
        }
    }
}

#Preview {
    InfoPurposeView()
        .modifier(PreviewMod(type:.card,width: 600))
}
