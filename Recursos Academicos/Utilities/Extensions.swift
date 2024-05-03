//
//  Extensions.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import UIKit
import Foundation
import SwiftUI

///This extension convert color from hex to Color type

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var red: Double = 0.0
        var green: Double = 0.0
        var blue: Double = 0.0
        var opacity: Double = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            red = Double((rgb & 0xFF0000) >> 16) / 255.0
            green = Double((rgb & 0x00FF00) >> 8) / 255.0
            blue = Double(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            red = Double((rgb & 0xFF000000) >> 24) / 255.0
            green = Double((rgb & 0x00FF0000) >> 16) / 255.0
            blue = Double((rgb & 0x0000FF00) >> 8) / 255.0
            opacity = Double(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

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



/// Función que valida que los inputs dentro sean validos
///
/// - Returns: Retorna un booleano indicando si las validaciones resultaron satisfactorias
//func validateInputs() -> Bool {
//    
//    //Obtener los parametros de los input correspondientes y checar por valores nulos y espacios en blanco
//    let userString = txtUser.text?.trimmingCharacters(in: .whitespaces)
//    let passwordString = txtPassword.text?.trimmingCharacters(in: .whitespaces)
//    //let isValidUserString = ValidationsHelper.validateEmail(enteredEmail: userString!)
//    let stringUserHasValue = userString!.isEmpty
//    let stringPasswordHasValue = passwordString!.isEmpty
//    
//    //Validar resultados de las validaciones
//    if  stringUserHasValue || stringPasswordHasValue {
//        txtUser.shake()
//        txtPassword.shake()
//        return false
//    } /*else if !isValidUserString {
//         ValidationsHelper.showAlert(self, alertTitle: "Usuario invalido", alertMessage: "El usuario no corresponde a un formato valido", alertActions: nil)
//         return false
//     } */else {
//        return true
//    }
//}
