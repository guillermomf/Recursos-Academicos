//
//  MessagesSrv.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 14/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class MessagesSrv {
    static let SharedInstance = MessagesSrv()
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /// Obtiene el listado de conversaciones activas del usuario
    ///
    /// - Parameter Result: Resultado con el listado de conversaciones
    func getUserConversations(Result:@escaping(Bool, [ConversationModel]) -> Void) {
        let url = Settings.userConversationsUrl
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var request = URLRequest(url: url)
        var convoList : [ConversationModel] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                DispatchQueue.main.async {
                    Result(false, convoList)
                }
            }
            
            if data == nil  {
                DispatchQueue.main.async {
                    Result(false, convoList)
                }
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    let jsonData = JSON(data)
                    
                    let success = jsonData["success"].bool ?? false
                    
                    if success {
                        DispatchQueue.main.async {
                            //Borrar las conversaciones almacenadas previamente
                            MessagesSrv.SharedInstance.deleteStoredConversations()
                            
                            if let conversationData = jsonData["data"].array {
                                for conversation in conversationData {
                                    let newConvo = ConversationModel(withJsonObject: conversation)
                                    convoList.append(newConvo)
                                }
                            }
                            
                            //Guardar el nuevo listado de conversaciones
                            _ = MessagesSrv.SharedInstance.storeUserConversations(convoList: convoList)
                            
                            Result(success, convoList)
                        }
                    } else { Result(success, convoList) }
                default:
                    Result(false, convoList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Almacena las conversaciones localmente en el dispositivo
    ///
    /// - Parameter convoList: Listado de conversaciones
    /// - Returns: Booleano indicando el resultado de la operación
    func storeUserConversations(convoList: [ConversationModel]) -> Bool {
        var result : Bool = true
        
        for convo in convoList {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Conversations", in: context)
            let newConvoRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newConvoRegistry.setValue(convo.chatGroupId , forKey: "chatGroupId")
            newConvoRegistry.setValue(convo.receiverAvatar , forKey: "receiverAvatar")
            newConvoRegistry.setValue(convo.isRead , forKey: "isRead")
            newConvoRegistry.setValue(convo.receiverEmail , forKey: "receiverEmail")
            newConvoRegistry.setValue(convo.lastMessageDateString , forKey: "lastMessageDateString")
            newConvoRegistry.setValue(convo.lastMessage , forKey: "lastMessage")
            newConvoRegistry.setValue(convo.receiverUserName , forKey: "receiverUserName")
            newConvoRegistry.setValue(convo.receiverUserId , forKey: "receiverUserId")
            newConvoRegistry.setValue(convo.owner , forKey: "owner")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia las conversaciones almacenadas en la BD del dispositivo
    func deleteStoredConversations() {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversations")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar las conversaciones de la BD", error)
        }
    }
    
    /// Obtiene las conversaciones almacenadas localmente en el dispositivo
    ///
    /// - Returns: Listado de conversaciones
    func getStoredConversations() -> [ConversationModel] {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversations")
        
        var convoList : [ConversationModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let newConvo = ConversationModel(withDbObject: data)
                convoList.append(newConvo)
            }
            
            return convoList
            
        } catch { return convoList }
    }
    
    ///Obtiene los mensajes de las conversaciones del usuario
    ///
    /// - Returns: El listado de mensajes del usuario con el receptor
    func getConversationMessages(chatGroupId: Int, Result:@escaping(Bool, [MessageModel]) -> Void) {
        
        let url = Settings.convoMessagesUrl(chatGroupId: chatGroupId)
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var request = URLRequest(url: url)
        var messageList : [MessageModel] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                DispatchQueue.main.async {
                    Result(false, messageList)
                }
            }
            
            if data == nil  {
                DispatchQueue.main.async {
                    Result(false, messageList)
                }
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    let jsonData = JSON(data)
                    
                    let success = jsonData["success"].bool ?? false
                    
                    if success {
                        DispatchQueue.main.async {
                            //Borrar mensajes previos a la consulta
                            MessagesSrv.SharedInstance.deleteStoredMessages(chatGroupId: chatGroupId)
                            
                            if let conversationData = jsonData["data"].array {
                                for conversation in conversationData {
                                    let newMessage = MessageModel(withJsonObject: conversation)
                                    messageList.append(newMessage)
                                }
                            }
                            
                            //Guardar el nuevo listado de conversaciones
                            _ = MessagesSrv.SharedInstance.storeConvoMessages(MessageList: messageList)
                            
                            Result(success, messageList)
                        }
                    } else { Result(success, messageList) }
                default:
                    Result(false, messageList)
                }
            }
        }
        
        task.resume()
    }
    
    /// Almacena las conversaciones localmente en el dispositivo
    ///
    /// - Parameter convoList: Listado de conversaciones
    /// - Returns: Booleano indicando el resultado de la operación
    func storeConvoMessages(MessageList: [MessageModel]) -> Bool {
        var result : Bool = true
        
        for message in MessageList {
            
            let context = DataController.shared.container.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Messages", in: context)
            let newMessageRegistry = NSManagedObject(entity: entity!, insertInto: context)
            
            newMessageRegistry.setValue(message.id , forKey: "id")
            newMessageRegistry.setValue(message.chatGroupId , forKey: "chatGroupId")
            newMessageRegistry.setValue(message.message , forKey: "message")
            newMessageRegistry.setValue(message.owner , forKey: "owner")
            newMessageRegistry.setValue(message.senderUserName , forKey: "senderUserName")
            newMessageRegistry.setValue(message.senderAvatar , forKey: "senderAvatar")
            newMessageRegistry.setValue(message.messageSequence , forKey: "messageSequence")
            newMessageRegistry.setValue(message.read , forKey: "read")
            newMessageRegistry.setValue(message.receiverName , forKey: "receiverName")
            newMessageRegistry.setValue(message.receiverAvatar , forKey: "receiverAvatar")
            newMessageRegistry.setValue(message.senderDateString , forKey: "senderDateString")
            
            do {
                try context.save()
            } catch {
                result = false
            }
        }
        
        return result
    }
    
    /// Metódo que vacia las conversaciones almacenadas en la BD del dispositivo
    func deleteStoredMessages(chatGroupId: Int) {
        let context = DataController.shared.container.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversations")
        fetch.predicate = NSPredicate(format: "chatGroupId = %@", chatGroupId.description)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try context.execute(request)
            try context.save()
        } catch {
            print ("Error al eliminar los mensajes de la BD", error)
        }
    }
    
    /// Obtiene las conversaciones almacenadas localmente en el dispositivo
    ///
    /// - Returns: Listado de conversaciones
    func getStoredMessages(chatGroupId: Int) -> [MessageModel] {
        let context = DataController.shared.container.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Conversations")
        request.predicate = NSPredicate(format: "chatGroupId = %@", chatGroupId.description)
        
        var messageList : [MessageModel] = []
        
        do {
            let result = try context.fetch(request)
            
            for data in result as! [NSManagedObject] {
                let newMessage = MessageModel(withDbObject: data)
                messageList.append(newMessage)
            }
            
            return messageList
            
        } catch { return messageList }
    }
    
    ///Envia un mensaje directo al receptor
    ///
    /// - Returns: El listado de mensajes del usuario con el receptor
    func sendMessage(receiverId: Int, chatGroupId: Int, message: String, Result:@escaping(Bool, MessageModel?) -> Void) {
        
        let url = Settings.sendMessageUrl
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var request = URLRequest(url: url)
        
        let parameters : Dictionary<String, Any> = [ "Message" : message,
                                                     "ReceiverUserId" : receiverId,
                                                     "ChatGroupId" : chatGroupId]
        
        let jsonParameters = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        
        request.httpMethod = "POST"
        request.httpBody = jsonParameters
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                DispatchQueue.main.async {
                    Result(false, nil)
                }
            }
            
            if data == nil  {
                DispatchQueue.main.async {
                    Result(false, nil)
                }
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    let jsonData = JSON(data)
                    
                    let success = jsonData["success"].bool ?? false
                    
                    if success {
                        let newMessage = MessageModel(forResponse: jsonData["data"])
                        Result(true, newMessage)
                    } else { Result(success, nil) }
                default:
                    Result(false, nil)
                }
            }
        }
        
        task.resume()
    }
    
    /// Obtiene el listado de contactos disponibles para el usuario
    ///
    /// - Parameter Result: Resultado con el listado de conversaciones
    func getAvailableContacts(Result:@escaping(Bool, [ContactModel]) -> Void) {
        let url = Settings.userContactsUrl
        let accessToken = UserDefaults.standard.string(forKey: Settings.userTokenKey)
        var request = URLRequest(url: url)
        var contactList : [ContactModel] = []
        
        request.httpMethod = "GET"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil  {
                DispatchQueue.main.async {
                    Result(false, contactList)
                }
            }
            
            if data == nil  {
                DispatchQueue.main.async {
                    Result(false, contactList)
                }
            }
            
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                
                switch statusCode {
                case 200...299:
                    let jsonData = JSON(data!)
                    
                    let success = jsonData["success"].bool ?? false
                    
                    if success {
                        DispatchQueue.main.async {
                            if let contactData = jsonData["data"].array {
                                for contact in contactData {
                                    let newContact = ContactModel(withJsonObject: contact)
                                    contactList.append(newContact)
                                }
                            }
                            Result(success, contactList)
                        }
                    } else { Result(success, contactList) }
                default:
                    Result(false, contactList)
                }
            }
        }
        
        task.resume()
    }
}
