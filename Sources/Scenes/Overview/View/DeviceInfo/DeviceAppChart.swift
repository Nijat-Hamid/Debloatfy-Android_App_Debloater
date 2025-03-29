//
//  PieChartView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/6/25.
//

import SwiftUI
import Charts

struct DeviceAppChart: View {
    @State private var selectedAngle: Double?
    
    private let data:[AppChartModel]
    private let totalAppCount:Int
    private let categoryRanges: [(category: String, range: Range<Double>)]
    
    init(data: [AppChartModel]) {
        self.data = data
        var total = 0
        categoryRanges = data.map {
            let newTotal = total + $0.count
            let result = (category:$0.category,range:Double(total) ..< Double(newTotal))
            total = newTotal
            return result
        }
        self.totalAppCount = total
    }
    
    var selectedItem: AppChartModel? {
        guard let selectedAngle else { return nil }
        if let selected = categoryRanges.firstIndex(where: {
            $0.range.contains(selectedAngle)
        }) {
            return data[selected]
        }
        return nil
    }
   
    
    var body: some View {
        Chart(data, id: \.category) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(0.7),
                angularInset: 6
            )
            .cornerRadius(8)
            .foregroundStyle(by: .value("Category", "\(item.category)"))
            .opacity(item.category == selectedItem?.category ? 1 : 0.8)
        }
        .chartAngleSelection(value: $selectedAngle)
        .chartLegend(alignment: .bottom, spacing: 24) 
        .chartForegroundStyleScale(
            domain: .automatic, range: [Color.reddish,Color.brandSecondary]
        )
        .chartBackground { chartProxy in
            GeometryReader { geometry in
                if let anchor = chartProxy.plotFrame {
                    let frame = geometry[anchor]
                    VStack(spacing: 6) {
                        Text("\(selectedItem?.category ?? "Total") Apps")
                            .font(.appTitle2)
                            .fontWeight(.semibold)
                        Text("\(selectedItem?.count.formatted() ?? totalAppCount.formatted())")
                            .font(.appTitle2)
                            .fontWeight(.medium)
                    }
                    .animation(.snappy, value: selectedItem?.category)
                    .contentTransition(.numericText())
                    .overlay {
                        ZStack {
                            Circle()
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                                .frame(width: frame.width + 25, height: frame.height + 25)
                            
                            Circle()
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1.5)
                                .frame(width: frame.width - 90, height: frame.height - 90 )
                        }
                    }
                    .position(x:frame.midX,y:frame.midY)
                }
            }
        }
        .padding(.top,12)
        .animation(.snappy, value: selectedItem?.category)
        .aspectRatio(contentMode: .fit)
        .modifier(SectionMod(sectionType: .fullWidth))
    }
}

#Preview {
    DeviceAppChart(data: AppChartModel.mockList)
        .modifier(PreviewMod(type: .card,width: 300))
}

