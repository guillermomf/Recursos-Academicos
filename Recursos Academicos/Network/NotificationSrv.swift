//
//  NotificationSrv.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 13/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
//import FirebaseMessaging
import SwiftyJSON
import CoreData

class NotificationSrv {
    static let SharedInstance = NotificationSrv()
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    ///Subscribir el token de notificaciones al servidor
    func registerDeviceToken(token: String, success: @escaping(Bool) -> Void) {
        let accessToken : String = UserDefaults.standard.string(forKey: Settings.userTokenKey) ?? ""
        let notificationId : String = UserDefaults.standard.string(forKey: Settings.userNotificationId) ?? ""
        let fireBaseToken : String = token
        let url = Settings.tokenRegistrationUrl
        
        let parameters : Dictionary<String, Any> = [ "Token" : fireBaseToken,
                                                     "ClientId" : 3,
                                                     "DeviceId" : notificationId]
        
        let jsonParameters = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = jsonParameters
        //request.setValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                success(false)
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                    
                case 200...299:
                    let jsonData = JSON(data)
                    
                    if let deviceId = jsonData["data"].string {
                        UserDefaults.standard.set(deviceId, forKey: Settings.userNotificationId)
                    }
                    
                    let result = jsonData["success"].bool ?? false
                    
                    success(result)
                case 400...499:
                    success(false)
                default:
                    success(false)
                }
            }
        }
        
        task.resume()
    }
    
    /// Obtiene el listado de topicos de notificaciones del usuario
    ///
    /// - Parameter result: Retorna una tupla de Bool-String indicado que se obtuvo el perfil de publicación y el mensaje (opcional) resultante del proceso
    func getUserTopics (result: @escaping(Bool, String?) -> Void) {
        
        let url = Settings.userProfileUrl
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                result(false, "Error al conectar con el servidor")
                return
            }
            
            guard let data = data else {
                result(false, "Datos del servicio vacios")
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                //print(statusCode)
                switch statusCode {
                    
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data).dictionary
                    
                    if let topics = jsonData?["data"]?["topics"].arrayObject {
                        DispatchQueue.main.async {
                            self.deleteStoredTopics()
                            _ = self.storeUserTopics(topicList: topics as! [String])
                            result(true, "Topics obtenidos exitosamente")
                        }
                    } else {
                        result(false, "No se pudo guardar la lista de topics")
                    }
                default:
                    let jsonTokenData = JSON(data).dictionary
                    let message = jsonTokenData?["message"]?.string
                    
                    result(false, message)
                }
            }
        }
        
        task.resume()
    }
    
    /// Metodo que almacena un arreglo de topicos para notificaciones del usuario
    ///
    /// - Parameter Topics: Arreglo de strings de los topicos del usuario logeado
    /// - Returns: Retorna un booleano indicando si se almaceno correctamente
    func storeUserTopics(topicList: [String]) -> Bool {
        
        var result : Bool = true
        
        for topic in topicList {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "UserTopics", in: context)
            let newTaskRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newTaskRegistry.setValue(topic , forKey: "topicName")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia los topicos almacenados en la BD del dispositivo
    func deleteStoredTopics() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTopics")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los topicos de la BD", error)
        }
        
    }
    
    /// Metódo que retorna los almacenados localmente en el dispositivo
    ///
    /// - Parameter success: Tupla que retorna el resultado de la consulta y el listado de topicos recuperados de la BD local
    func getStoredTopics(Result: @escaping([String]) -> Void ) {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserTopics")
        
        var topicList : [String] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                
                let newTopic = data.value(forKey: "topicName") as! String
                topicList.append(newTopic)
            }
            
            return Result(topicList)
        } catch {
            return Result(topicList)
        }
    }
    
    /// Obtiene el listado de notificaciones del usuario
    ///
    /// - Parameter result: Retorna una tupla de Bool-String indicado que se obtuvo el perfil de publicación y el mensaje (opcional) resultante del proceso
    func getUserNotifications (page: Int, pageSize: Int, result: @escaping(Bool, [NotificationModel], ListPagination?) -> Void) {
        
        let urlString = Settings.userNotificationsInboxUrl.absoluteString + "page=\(page)&sizePage=\(pageSize)"
        let url = URL(string: urlString)!
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var notificationList : [NotificationModel] = []
        var paginationItem : ListPagination?
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                result(false, notificationList, nil)
                return
            }
            
            guard let data = data else {
                result(false, notificationList, nil)
                return
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                //print(statusCode)
                switch statusCode {
                    
                case 200...299:
                    //Convertir resultado esperado a formato JSON
                    let jsonData = JSON(data).dictionary
                    let success = jsonData?["success"]?.bool ?? false
                    
                    if success  {
                        if let notifications = jsonData?["data"]?.array {
                            for notification in notifications {
                                let newNotification = NotificationModel(withJsonObject: notification)
                                notificationList.append(newNotification)
                            }
                        }
                        
                        if let pagination = jsonData?["pagination"] {
                            let newPagination = ListPagination(withJsonObject: pagination)
                            paginationItem = newPagination
                        }
                    }
                    
                    result(success, notificationList, paginationItem)
                default:
                    result(false, notificationList, nil)
                }
            }
        }
        
        task.resume()
    }
}
