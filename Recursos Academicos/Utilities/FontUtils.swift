//
//  FontUtils.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import UIKit
import SwiftUI

enum FontKeys: String, CaseIterable {
    case robotoBold = "Roboto-Bold"
    case robotoMedium = "Roboto-Medium"
    case robotoregular = "Roboto-Regular"
    case robotolight = "Roboto-Light"
}

/// Clase de utils para obtener la fuente deseada
final class FontUtils {
    
    /// Función para obtener alguna fuente registrada del proyecto
    /// - Parameters:
    ///   - key: Llave de la fuente
    ///   - size: Tamaño de la fuente
    /// - Returns: Una fuente registrada del sistema, en otro caso regresa el System Font
    static func get(for key: FontKeys, size: CGFloat) -> UIFont {
        let font = UIFont(name: key.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
        return font
    }
}

struct FontModifier: ViewModifier {
    
    var fontKey: FontKeys
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content.font(.custom(fontKey.rawValue, size: size, relativeTo: getRelativeStyle(size: size)))
    }
    
    
    /// Función para obtener un tamaño relativo dependiendo del parámetro recibido
    /// - Parameter size: Tamaño recibido
    /// - Returns: Estilo de texto dependiendo del tamaño
    private func getRelativeStyle(size: CGFloat) -> Font.TextStyle {
        switch size {
        case 0..<11:
            return .caption2
        case 12:
            return .caption
        case 13..<14:
            return .footnote
        case 14..<19:
            return .body
        case 20..<21:
            return .title3
        case 22..<27:
            return .title2
        case 28..<33:
            return .title
        case 33..<100:
            return .largeTitle
        default:
            return .body
        }
    }
}


extension View {
    @ViewBuilder
    func customFont(fontKey: FontKeys, size: CGFloat) -> some View {
        self.modifier(FontModifier(fontKey: fontKey, size: size))
    }
}
