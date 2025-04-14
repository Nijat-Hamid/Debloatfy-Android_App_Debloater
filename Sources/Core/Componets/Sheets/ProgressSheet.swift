//
//  ProgressSheet.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 4/12/25.
//

import SwiftUI

enum ProgressSheetType {
    case copyToPC
    case copyToPhone
    case delete
    
    var image:(String,String) {
        switch self {
        case .copyToPC:
            return ("iphone","macbook")
        case .copyToPhone:
            return ("macbook","iphone")
        case .delete:
            return ("document.on.document.fill","arrow.up.trash.fill")
        }
    }
    
    var imageSizes: [(CGFloat?, CGFloat?)] {
        switch self {
        case .copyToPC:
            return [(32, nil), (nil, 44)]
        case .copyToPhone:
            return [(nil, 44), (32, nil)]
        case .delete:
            return [(36, nil), (nil, 42)]
        }
    }
    
    var processNames:(String,String) {
        switch self {
        case .copyToPC, .copyToPhone: return ("Copied!","Copying...")
        case .delete: return ("Deleted!","Deleting...")
        }
    }
}

struct ProgressSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var progress: Float
    @State private var timer: Timer?
    private let isCompleted: Bool
    private let type:ProgressSheetType
    private let fileName:String
    private let cancelAction: () async -> Void
    private var isActuallyCompleted: Bool {
        isCompleted && progress >= 100
    }
    
    init(progress: Binding<Float>,
         fileName:String = "N/A",
         isCompleted: Bool,
         type:ProgressSheetType,
         cancelAction: @escaping () async -> Void
    ) {
        self.isCompleted = isCompleted
        self.type = type
        self._progress = progress
        self.fileName = fileName
        self.cancelAction = cancelAction
    }
    
    var body: some View {
        VStack(spacing:32) {
            HStack(spacing:32) {
                Image(systemName: type.image.0)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary,.brand)
                    .frame(width:type.imageSizes[0].0, height: type.imageSizes[0].1)
                
                Image(systemName: "arrow.forward")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width:32)
                
                Image(systemName: type.image.1)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.primary,.brand)
                    .frame(width:type.imageSizes[1].0, height: type.imageSizes[1].1)
            }
            
            VStack(spacing:26) {
                ProgressView(value: progress, total: 100) {
                    Text(isActuallyCompleted ? type.processNames.0 : type.processNames.1)
                        .fontWeight(.semibold)
                        .contentTransition(.interpolate)
                } currentValueLabel: {
                    Text(isActuallyCompleted ? "Done: \(Int(progress))%":"Current progress: \(Int(progress))%")
                        .contentTransition(.interpolate)
                        .animation(.default, value: progress)
                    
                    Text("Data: \(fileName)")
                }
                .tint(.brand)
                
                Button {
                    if isActuallyCompleted {
                        dismiss()
                    } else {
                        Task {
                            await cancelAction()
                            dismiss()
                        }
                    }
                } label: {
                    Text(isActuallyCompleted ? "Close":"Terminate")
                        .fontWeight(.semibold)
                        .contentTransition(.interpolate)
                        .frame(width:80)
                }
                .buttonStyle(ButtonStyles(
                    type: isActuallyCompleted ? .success : .danger,
                    disable: isCompleted && !isActuallyCompleted,
                    padV: 6,
                    pointerStyle: .link))
                
            }
        }
        .padding(32)
        .onAppear {
            startProgressLoop()
        }
        .onDisappear {
            timer?.invalidate()
            progress = 0
        }
        .onChange(of: isCompleted) { _, newValue in
            if newValue {
                startProgressLoop()
            }
        }
        
    }
    
    
    private func startProgressLoop() {
        timer?.invalidate()
        
        let interval = isCompleted ? 0.05 : 0.95
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            if isCompleted {
                if progress < 100 {
                    progress = min(progress + 4, 100)
                } else {
                    timer?.invalidate()
                }
            } else {
                if progress < 90 {
                    progress = min(progress + 1, 100)
                } else {
                    progress = Float.random(in: 30...60)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var progress: Float = 0
    ProgressSheet(progress: $progress, isCompleted: true,type: .delete, cancelAction: {})
        .frame(width: 400, height: 260)
}
