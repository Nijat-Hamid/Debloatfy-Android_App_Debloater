//
//  DevinceInfoImage.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/4/25.
//

import SwiftUI

struct DevinceInfoImage: View {
    var body: some View {
        ZStack {
            Image("smartphone")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130)
            
            VStack(spacing:12) {
                Image("androidLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80)
                
                Text("android")
                    .font(.appTitle2)
            }
            .foregroundStyle(.greenish.gradient)
        }
    }
}

#Preview {
    DevinceInfoImage()
        .modifier(PreviewMod(type: .card,width: nil))
}
