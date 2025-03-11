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
                .frame(maxHeight: .infinity)
            
            VStack(spacing:12) {
                Image("androidLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150)
                
                Text("android")
                    .font(.appLargeTitle)
            }
            .foregroundStyle(.greenish.gradient)
        }
        .modifier(SectionMod(sectionType: .automatic))
    }
}

#Preview {
    DevinceInfoImage()
        .modifier(PreviewMod(type: .card,width: nil))
}
