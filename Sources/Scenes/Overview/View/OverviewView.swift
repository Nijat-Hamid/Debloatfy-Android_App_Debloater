//
//  OverviewView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct OverviewView: View {
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                DevinceInfoImage()
                Spacer()
                DeviceInfoParams()
                Spacer()
                DeviceAppChart()
            }
            .modifier(SectionMod())
            Spacer()
        }
    }
}

#Preview {
    OverviewView()
}
