//
//  Extensions.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 03/05/24.
//

import Foundation
import SwiftUI

public extension View {
    func transparentScrolling() -> some View {
        if #available(iOS 16.0, *) {
            return scrollContentBackground(.hidden)
        } else {
            return onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
        }
    }
}
