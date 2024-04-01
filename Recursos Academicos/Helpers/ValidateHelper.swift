//
//  Helpers.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import Foundation
import UIKit
import CoreData

class ValidationsHelper {
    
    /// Metódo que verifica que el string pertenezca a una formato de correo valida
    ///
    /// - Parameter enteredEmail: String a validar
    /// - Returns: Retorna un booleano indicando si la validación haya resultado satisfactoria
    static func validateEmail(enteredEmail:String) -> Bool {
        
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
}


class DataController {
    static let shared = DataController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Recursos_Academicos")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("No se puede cargar el almacén persistente: \(error)")
            }
        }
    }

    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error al guardar el contexto: \(error.localizedDescription)")
            }
        }
    }
}
