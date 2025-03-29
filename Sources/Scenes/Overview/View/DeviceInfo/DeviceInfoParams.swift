//
//  DeviceInfoParams.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/4/25.
//

import SwiftUI

struct DeviceInfoParams: View {
    
    private let data:DeviceParamsModel
    
    init(data: DeviceParamsModel) {
        self.data = data
    }
    
    var body: some View {
        HStack(spacing: 12){
            VStack(alignment:.leading,spacing: 16) {
                Creator.infoRow(title: "Company:", value: data.companyName, icon: "link.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Model:", value: data.deviceModel, icon: "iphone.gen3.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Android:", value: data.androidVersion, icon: "gear.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Security:", value: data.securityPatch, icon: "lock.circle",size: .init(width: 20, height: 20))
            }
            .modifier(SectionMod(sectionType: .fullWidth,alignment: .leading))
            VStack(alignment:.leading,spacing: 16) {
                Creator.infoRow(title: "ID:", value: data.deviceID, icon: "dot.arrowtriangles.up.right.down.left.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "BL:", value: data.deviceBL, icon: "square.and.pencil.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Build:", value: data.build, icon: "arrow.trianglehead.2.clockwise.rotate.90.circle",size: .init(width: 20, height: 20))
                Creator.infoRow(title: "Product:", value: data.product, icon: "leaf.circle",size: .init(width: 20, height: 20))
            }
            .modifier(SectionMod(sectionType: .fullWidth, alignment: .leading))
            
        }
    }
}

#Preview {
    DeviceInfoParams(data: DeviceParamsModel.mock)
        .modifier(PreviewMod(type:.card,width: 500))
}
