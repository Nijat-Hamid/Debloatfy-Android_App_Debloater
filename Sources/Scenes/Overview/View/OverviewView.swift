//
//  OverviewView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 2/19/25.
//

import SwiftUI

struct OverviewView: View {
    @Environment(\.auth) private var auth
    @State private var vm = OverviewVM()
    
    var body: some View {
        Group {
            if vm.isLoading {
                LoadingView()
            } else {
                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        DevinceInfoImage()
                        VStack(alignment: .leading, spacing: 12) {
                            DeviceInfoParams(data: vm.deviceParams)
                            DeviceAppChart(data: vm.appChartData)
                        }
                    }
                }
            }
        }
        .task {
            await vm.getDeviceData()
        }
    }

}

#Preview {
    OverviewView()
}
