//
//  PieChartView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/6/25.
//

import SwiftUI
import Charts

struct DeviceAppChart: View {
    
    let data: [AppCount] = apps
    
    @State private var selectedAngle: Double?
    
    var body: some View {
        Chart(data, id: \.category) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(0.6),
                angularInset: 10
            )
            .cornerRadius(8)
            .foregroundStyle(by: .value("Category", item.category))
        }
        .chartLegend(alignment: .center, spacing: 20)
        .chartForegroundStyleScale(
            domain: .automatic, range: [Color.orangeish,Color.brandSecondary,Color.greenish]
        )
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    VStack {
                        Text("Total Apps")
                        Text("160")
                    }
                    .position(x:frame.midX,y:frame.midY)
                        
                }
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: 260)
    }
}

#Preview {
    DeviceAppChart()
        .modifier(PreviewMod(type: .card,width: nil))
}


struct AppCount {
    var category: String
    var count: Int
}

let apps: [AppCount] = [
    .init(category: "System", count: 120),
    .init(category: "Thirdy Party", count: 40)
]
