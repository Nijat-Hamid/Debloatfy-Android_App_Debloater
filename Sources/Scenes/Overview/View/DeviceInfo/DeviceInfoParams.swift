//
//  DeviceInfoParams.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/4/25.
//

import SwiftUI

struct DeviceInfoParams: View {
    var body: some View {
        HStack(spacing: 12){
            VStack(alignment:.leading,spacing: 16) {
                Creator.infoRow(title: "Company:", value: "Samsung", icon: "link.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Model:", value: "SM-S916B", icon: "iphone.gen3.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Android:", value: "v15", icon: "gear.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Security:", value: "2025-02-01", icon: "lock.circle",size: .init(width: 20, height: 20))
            }
            .modifier(SectionMod(sectionType: .fullWidth))
            VStack(alignment:.leading,spacing: 16) {
                Creator.infoRow(title: "ID:", value: "R5CW22MLZ7H", icon: "dot.arrowtriangles.up.right.down.left.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "BL:", value: "S916BXXU8CYB4", icon: "square.and.pencil.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Build:", value: "UP1A.231005.007.S916BXXU8CYB4", icon: "arrow.trianglehead.2.clockwise.rotate.90.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Product:", value: "dm2qxxx", icon: "leaf.circle",size: .init(width: 20, height: 20))
            }
            .modifier(SectionMod(sectionType: .fullWidth))
            
        }
    }
}

#Preview {
    DeviceInfoParams()
        .modifier(PreviewMod(type:.card,width: nil))
}
