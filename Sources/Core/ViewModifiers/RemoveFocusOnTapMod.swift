//
//  RemoveFocusOnTapMod.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/7/25.
//
import SwiftUI

struct RemoveFocusOnTapModifier: ViewModifier {
     func body(content: Content) -> some View {
        content
            .onTapGesture {
                DispatchQueue.main.async {
                    NSApp.keyWindow?.makeFirstResponder(nil)
                }
            }
            .onDisappear {
                DispatchQueue.main.async {
                    NSApp.keyWindow?.makeFirstResponder(nil)
                }
            }
    }
}
