//
//  OverviewView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct OverviewView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing:12) {
                DevinceInfoImage()
                VStack(alignment: .leading,spacing: 12) {
                    DeviceInfoParams()
                    DeviceAppChart()
                }
            }
            Spacer()
        }
        
//        VStack{
//            HStack(alignment: .center) {
//                DevinceInfoImage()
//                Spacer()
//                DeviceInfoParams()
//                Spacer()
//                DeviceAppChart()
//            }
//            .modifier(SectionMod())
//            Spacer()
//        }
    }
}

#Preview {
    OverviewView()
}
