//
//  LogListItem.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/22/25.
//

import SwiftUI

extension LogListItem {
    enum TypeDetails {
        static func color(for type:DBModel.LogType?) -> Color {
            switch type {
            case .transfer: .mute.opacity(0.5)
            case .remove,.fileRemove: .reddish
            case .backup,.restore: .greenish
            case .backupRemove, .restoreRemove: .yellowish
            default: .mute.opacity(0.5)
            }
        }
    }
}

struct LogListItem: View {
    private let log:DBModel
    
    init(log: DBModel) {
        self.log = log
    }
    
    var body: some View {
        HStack {
            Text(Utils.dateFormatter(log.date))
                .frame(width:160,alignment: .leading)
            
            Spacer()
            
            Text(DBModel.LogType.safeTitle(from: log.type))
                .font(.appSubHeadline)
                .padding(.horizontal, 6)
                .padding(.vertical,4)
                .background(TypeDetails.color(for: DBModel.LogType(rawValue: log.type)),in: .rect(cornerRadius: 8))
                .frame(width: 140)
            
            Spacer()
            
            Text(log.name)
                .frame(width:160)
            
            Spacer()
            
            Text(log.message)
                .frame(maxWidth: .infinity)
        }
        .frame(width:790, height: 32)
    }
}

#Preview {
    LogListItem(log: DBModel.mock)
}
