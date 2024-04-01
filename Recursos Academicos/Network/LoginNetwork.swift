//
//  LoginNetwork.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 08/03/24.
//


import Foundation
import SwiftyJSON
//import Firebase
import SwiftUI

class SecuritySrv: ObservableObject {
    static let SharedInstance = SecuritySrv()
    
    var currentToken : ModelToken?
    @Published var goToTabBar: Bool = false
    
    /// Servicio que realiza una solicitud de un token de acceso para usuario
    ///
    /// - Parameters:
    ///   - user: Nombre de usuario
    ///   - password: Contraseña
    ///   - result: Resultado del servicio web un booleano representativo del suceso la operación y un string en caso de existir mensajes de error en el resultado de la petición
    func requestAccessToken (user: String, password: String, result: @escaping(Bool, String?) -> Void) {
        
        let url = Settings.tokenUrl
        
        let parameters = "grant_type=password&username=\(user)&password=\(password)&origen_id=2"
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                result(false, "Error al contactar con el servidor, revise su conexión a internet o intente de nuevo mas tarde")
                return
            }
            
            guard let data = data else {
                result(false, "Error al obtener los datos del servidor")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                    
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonTokenData = JSON(data)
                    
                    let userRole = jsonTokenData["rol"].string ?? "admin"
                    
                    let tokenStr = jsonTokenData["access_token"].string
                    let userName = jsonTokenData["userName"].string
                    let fullName = jsonTokenData["fullName"].string
                    let email = jsonTokenData["email"].string
                    
                    let tokenRefresh = jsonTokenData["refresh_token"].string
                    
                    let newToken = ModelToken(tokenString: tokenStr!,refreshToken: tokenRefresh ?? "", userName: userName!, email: email!, fullName: fullName!, role: userRole)
                    newToken.token_type = jsonTokenData ["token_type"].string
                    newToken.issued = jsonTokenData[".issued"].string
                    newToken.expires = jsonTokenData[".expires"].string
                    newToken.expires_in = jsonTokenData["expires_in"].int
                    
                    self.currentToken = newToken
                    
                    result(true, nil)
                case 400...499:
                    let errorData = JSON(data).dictionary
                    let errorString = errorData?["error"]?.string
                    
                    result(false, errorString)
                default:
                    result(false, "Error al contactar con el servidor")
                }
            }
        }
        
        task.resume()
    }
    
    /// Verifica que exista un token de acceso previamente almacenado en el dispositivo indicando si existe un usuario logeado en el sistema.
    ///
    /// - Returns: Retorna un booleano indicando el estatus de Acceso
    static func isUserLoggedIn() -> Bool {
        //Verificar que exista un token de acceso previo en el dispositivo
        if UserDefaults.standard.value(forKey: Settings.userTokenKey) != nil {
            return true
        } else {
            return false
        }
    }
    
    /// Metódo que verifica la validez del token de sesión actual
    ///
    /// - Parameter success: Booleano indicando el resultado de la validación
    static func validateSession(success: @escaping(Bool) -> Void) {
        let currentToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        let url = Settings.sessionValidationUrl
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(currentToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                print(error!.localizedDescription)
                success(true)
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                    
                case 401:
                    success(false)
                default:
                    success(true)
                }
            }
        }
        
        task.resume()
    }
    
    ///Actualiza el token de acceso del usuario
    func refreshToken(success: @escaping(Bool) -> Void) {
        let tokenRefresh : String = UserDefaults.standard.string(forKey: Settings.userRefreshKey) ?? "N/A"
        let url = Settings.tokenUrl
        
        let parameters = "refresh_token=\(tokenRefresh)&grant_type=refresh_token&client_id=mobile_ios"
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        request.setValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                success(true)
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                    
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonTokenData = JSON(data)
                    
                    let tokenStr = jsonTokenData["access_token"].string
                    let userName = jsonTokenData["userName"].string
                    let fullName = jsonTokenData["fullName"].string
                    let email = jsonTokenData["email"].string
                    let userRole = jsonTokenData["rol"].string
                    let tokenRefresh = jsonTokenData["refresh_token"].string
                    
                    let newToken = ModelToken(tokenString: tokenStr!,refreshToken: tokenRefresh ?? UserDefaults.standard.string(forKey: Settings.userRefreshKey)!, userName: userName!, email: email!, fullName: fullName!, role: userRole!)
                    newToken.token_type = jsonTokenData ["token_type"].string
                    newToken.issued = jsonTokenData[".issued"].string
                    newToken.expires = jsonTokenData[".expires"].string
                    newToken.expires_in = jsonTokenData["expires_in"].int
                    
                    self.currentToken = newToken
                    
                    success(true)
                case 400...499:
                    success(false)
                default:
                    success(true)
                }
            }
        }
        
        task.resume()
    }
    
    /// Realiza un logout de la sesión activa
    ///
    /// - Parameter viewController: Vista en la cual se esta realizando el logout de no especificarse solo se realizaran las funciones de logout sin eliminar la vista.
    //TODO: Checar esta funcion con Firebase 
//    static func logOut(_ viewController: UIViewController?) {
//        if self.SharedInstance.currentToken != nil {
//            self.SharedInstance.currentToken = nil
//        }
//
//        UserDefaults.standard.removeObject(forKey: Settings.userTokenKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userRefreshKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userEmailKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userNameKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userFullNameKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userRoleKey)
//        UserDefaults.standard.removeObject(forKey: Settings.userImageUrl)
//
//        //Eliminar datos adicionales del usuario
//        ScoreSrv.SharedInstance.deleteStoredScores()
//        ContentSrv.SharedInstance.deleteStoredPermissions()
//
//        InstanceID.instanceID().deleteID { (error) in
//            if error != nil {
//                print("Error al borrar el InstanceId: ", error)
//            }
//
//            if let currentViewController = viewController {
//                switch UIDevice.current.userInterfaceIdiom {
//                case .phone:
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginCtr
//                    InstanceID.instanceID().instanceID(handler: { (result, error) in
//                     if error != nil {
//                     print("Error al generar un nuevo InstanceId: ", error)
//                     }
//                     })
//                    currentViewController.present(nextViewController, animated:true, completion:nil)
//                case .pad:
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginCtr
//                    InstanceID.instanceID().instanceID(handler: { (result, error) in
//                     if error != nil {
//                     print("Error al generar un nuevo InstanceId: ", error)
//                     }
//                     })
//                    currentViewController.present(nextViewController, animated:true, completion:nil)
//                default:
//                    break
//                }
//
//            }
//        }
//    }
    
    /// Obtiene la imagen de perfil del usuario
    ///
    /// - Parameter result: Retorna una tupla de Bool-String indicado que se obtuvo el perfil de publicación y la URL (opcional) resultante del proceso
    static func getUserProfileImage (result: @escaping(Bool, String?) -> Void) {
        
        let url = Settings.userProfileUrl
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                result(false, nil)
                return
            }
            
            guard let data = data else {
                result(false, nil)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                    
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonTokenData = JSON(data).dictionary
                    //Obtener la imagen de perfil del usuario
                    let imageUrl = jsonTokenData?["data"]!["user"]["urlImage"].string
                    
                    if let imageUrl = imageUrl {
                        UserDefaults.standard.set(imageUrl, forKey: Settings.userImageUrl)
                        result(true, imageUrl)
                    } else {
                        result(false, nil)
                    }
                default:
                    result(false, nil)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metódo que realiza la recuperación de contraseña del usuario, solicita el envio de un correo de recuperación.
    ///
    /// - Parameters:
    ///   - email: Dirección de correo registrada por el usuario
    ///   - result: Tupla que contiene un booleano indicando el estatus de la operación, de ser falso retorna un mensaje de acuerdo a la respuesta del servidor.
    static func sendPasswordRecovery (email: String, result: @escaping(Bool, String?) -> Void) {
        
        let url = Settings.passwordRecoveryUrl
        
        let parameters :  [String : Any] = ["email" : email, "systemId": 2]
        let jsonParameters = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = jsonParameters
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                result(false, nil)
                return
            }
            
            guard let data = data else {
                result(false, nil)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                    
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonTokenData = JSON(data).dictionary
                    
                    let success = jsonTokenData?["success"]?.bool
                    let message = jsonTokenData?["message"]?.string
                    
                    result(success!, message)
                case 400...499:
                    let jsonTokenData = JSON(data).dictionary
                    
                    let message = jsonTokenData?["message"]?.string
                    
                    result(false, message)
                default:
                    let jsonTokenData = JSON(data).dictionary
                    
                    let message = jsonTokenData?["message"]?.string
                    
                    result(false, message)
                }
            }
        }
        
        task.resume()
    }
    
}



