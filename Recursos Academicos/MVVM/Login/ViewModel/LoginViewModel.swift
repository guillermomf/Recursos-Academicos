//
//  LoginViewModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//

import Foundation
import SwiftyJSON
//import Firebase
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var goToTabBar: Bool = false
    @Published var isLoading: Bool = false
    @Published var user: String = String()
    @Published var password: String = String()
    @Published var showPassword: Bool = false
    @Published var showPrivacityNotice: Bool = false
    @Published var showLoader: Bool = false
    
    /// Función que realiza el inicio de sesión del usuario movil en el sistema
    ///
    /// - Parameters:
    ///   - username: Nombre de usuario
    ///   - password: Contraseña
    func userLogIn(username : String, password : String) {
        SecuritySrv.SharedInstance.requestAccessToken(user: username, password: password) { (success, errorMessage) in
            if success {
                //Enviar al usuario a la pantalla de Inicio
                DispatchQueue.main.async {
                    ContentSrv.SharedInstance.getUserBrandingTier(Result: {
                        DispatchQueue.main.async {
                            self.goToTabBar.toggle()
                            self.isLoading = false
                            //                        self.performSegue(withIdentifier: "segueHome", sender: self)
                        }
                    })
                }
            } else {
                //Mostrar al usuario una alerta indicando el motivo del fallo de inicio de sesión
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let errorMessage = errorMessage {
                        print(errorMessage)
                        //                    ValidationsHelper.showAlert(self, alertTitle: nil, alertMessage: errorMessage, alertActions: nil)
                    } else {
                        //                    ValidationsHelper.showAlert(self, alertTitle: nil, alertMessage: "Error al contactar con el servidor", alertActions: nil)
                    }
                }
            }
        }
    }
}


