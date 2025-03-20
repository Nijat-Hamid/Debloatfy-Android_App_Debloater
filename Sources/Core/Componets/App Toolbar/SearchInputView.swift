//
//  SearchInputView.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/7/25.
//

import SwiftUI

struct SearchInputView: View {
    
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    private let maxLength = 20
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextField("Search App", text: $searchText)
                .textFieldStyle(.plain)
                .padding(.vertical,6)
                .padding(.leading,8)
                .padding(.trailing,24)
                .disableAutocorrection(true)
                .background(.clear)
                .font(.appHeadline)
                .fontWeight(.semibold)
                .focused($isSearchFocused)
                .clipShape(.rect(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSearchFocused ? Color.brandSecondary : Color.secondary.opacity(0.5), lineWidth: 2)
                )
                .animation(.snappy(duration: 0.3), value: isSearchFocused)
                .onTapGesture {
                    isSearchFocused = true
                }
                .onChange(of: searchText) { _,newValue in
                    let filtered = newValue.filter { !$0.isWhitespace }
                    
                    if filtered != newValue {
                        searchText = filtered
                    }
                    

                    if filtered.count > maxLength {
                        searchText = String(filtered.prefix(maxLength))
                    }
                }
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                    isSearchFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(.secondary)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16)
                }
                .zIndex(1)
                .buttonStyle(.plain)
                .padding(.trailing,12)
                .modifier(BlurryTransitionMod())
            }
        }
        .frame(width: 170)
    }
}

#Preview {
    SearchInputView()
        .modifier(PreviewMod(type: .card,width: 250))
}
