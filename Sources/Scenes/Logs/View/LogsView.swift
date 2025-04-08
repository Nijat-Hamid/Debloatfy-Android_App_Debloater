//
//  LogsView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//

import SwiftUI

struct LogsView: View {
    
    @State private var vm = LogsVM(logger: .shared)
    
    var body: some View {
        VStack(spacing:4) {
            LogListHeader()
            VStack(spacing:16) {
                List {
                    ForEach(vm.logList) { item in
                        LogListItem()
                            .listRowInsets(.init(top: 4, leading: -8, bottom: 4, trailing: 0))
                    }
                    
                }
                .padding(.trailing, -14)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                
                Button {
                    print("clear all logs")
                } label: {
                    Text("Clear Logs")
                }
                .buttonStyle(ButtonStyles(type:.normal,padH: 12))
                .frame(maxWidth:.infinity,alignment: .trailing)
            }
        }
        .modifier(SectionMod(sectionType: .fullWidth))
    }
}

#Preview {
    LogsView()
}
