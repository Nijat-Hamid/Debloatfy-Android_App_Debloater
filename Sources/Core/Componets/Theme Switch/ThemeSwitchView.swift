//
//  ThemeSwitchView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/1/25.
//

import SwiftUI

struct ThemeSwitchView: View {
    var scheme:ColorScheme
    @AppStorage("userTheme") private var userTheme:Theme = .dark
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing:8) {
            ThemeIconView(scheme: scheme,size: CGSize(width: 80, height: 80))
            
            Text("Choose a Style")
                .font(.appTitle3)
                .fontWeight(.heavy)
                .padding(.top,12)
            
            Text("Day or night. \nCustomize your interface.")
                .multilineTextAlignment(.center)
                .font(.appHeadline)
                .fontWeight(.semibold)
                .padding(.bottom,4)
            
            HStack(spacing:0){
                ForEach(Theme.allCases,id:\.rawValue) { theme in
                    Text(theme.rawValue)
                        .font(.appCallout)
                        .fontWeight(.medium)
                        .padding(.vertical,6)
                        .frame(width: 70)
                        .background {
                            ZStack {
                                if userTheme == theme {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.hover)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                            .animation(.snappy, value: userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .background(.backgroundCard,in: .rect(cornerRadius: 8))
        }
        .padding()
        .background(Color.backgroundPrimary.ignoresSafeArea())
        .modifier(ColorSchemeTransition())
    }
}

#Preview {
    HStack (spacing:8) {
        ThemeSwitchView(scheme: .dark)
        ThemeSwitchView(scheme: .light)
    }
    
}
