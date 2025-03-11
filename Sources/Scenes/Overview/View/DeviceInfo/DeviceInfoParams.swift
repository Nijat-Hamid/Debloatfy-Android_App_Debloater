//
//  DeviceInfoParams.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/4/25.
//

import SwiftUI

struct DeviceInfoParams: View {
    var body: some View {
        HStack{
            VStack(alignment:.leading,spacing: 16) {
                Creator.infoRow(title: "Manufacturer:", value: "Samsung", icon: "link.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Model:", value: "SM-S916B", icon: "iphone.gen3.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Android:", value: "v15", icon: "gear.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Security Update:", value: "2025-02-01", icon: "lock.circle",size: .init(width: 20, height: 20))
            }
        }
    }
}

#Preview {
    DeviceInfoParams()
        .modifier(PreviewMod(type:.card,width: nil))
}
