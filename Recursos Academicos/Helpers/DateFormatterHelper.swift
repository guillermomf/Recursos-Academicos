//
//  DateFormatterHelper.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 13/03/24.
//

import Foundation

///This function allow return the data who ask in the view
/// - Parameters:
///    - date: Date from API
/// - Returns: The date in the new formatter.
///
func dateFormatterHelper(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy"
    let year: String = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "MMM"
    let month: String = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "dd"
    let day: String = dateFormatter.string(from: date)
    dateFormatter.dateFormat = "HH:mm"
    let sentTime: String = dateFormatter.string(from: date)
    
    let finalDate = "\(sentTime) | \(month), \(day)"
    
    return finalDate
}

/// Convierte una fecha en una cadena formateada.
/// - Parameters:
///   - date: La fecha a convertir.
///   - format: El formato de salida deseado.
///   - localeIdentifier: El identificador de localización opcional (por defecto es "es_ES").
/// - Returns: Una cadena representando la fecha en el formato especificado.
func formatDateToString(date: Date, format: String, localeIdentifier: String = "es_ES") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.locale = Locale(identifier: localeIdentifier)
    return dateFormatter.string(from: date)
}
