//
//  LogsView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//

import SwiftUI

struct LogsView: View {
    @State private var vm = LogsVM()
    
    var body: some View {
        VStack(spacing:4) {
            LogListHeader()
            Group {
                if vm.isLoading {
                    LoadingView()
                } else {
                    VStack(spacing:16) {
                        List {
                            ForEach(vm.logList) { log in
                                LogListItem(log:log)
                                    .listRowInsets(.init(top: 4, leading: -8, bottom: 4, trailing: 0))
                            }
                        }
                        .padding(.trailing, -14)
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        
                        Button {
                            Task {
                                await vm.removeLogs()
                            }
                        } label: {
                            Text("Clear Logs")
                        }
                        .buttonStyle(ButtonStyles(
                            type:.normal,
                            disable: vm.logList.isEmpty || vm.isProceeding,
                            padV: 6,
                            pointerStyle: .link))
                        .frame(maxWidth:.infinity,alignment: .trailing)
                    }
                    .modifier(UnavailableMod(type: vm.logList.isEmpty ? .empty : .none ))
                }
            }
        }
        .modifier(SectionMod(sectionType: .fullWidth))
        .task {
            await vm.fetchLogs()
        }
    }
}

#Preview {
    LogsView()
}
