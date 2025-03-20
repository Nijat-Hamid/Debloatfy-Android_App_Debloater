//
//  View+Extension.swift
//  Debloatfy
//
//  Created by Nijat Hamid on 3/19/25.
//
import SwiftUI

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
