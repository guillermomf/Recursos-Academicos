//
//  MessageModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import Foundation
import CoreData
import SwiftyJSON

class ConversationModel {
    var receiverAvatar : String?
    var chatGroupId : Int
    var isRead : Bool
    var receiverEmail : String?
    var lastMessageDateString : String?
    var lastMessageDate : Date?
    var lastMessage : String?
    var receiverUserName : String
    var receiverUserId : Int
    var owner : Bool
    
    init(withJsonObject json : JSON) {
        
        receiverAvatar = json["receiverAvatar"].string
        chatGroupId = json["chatGroupId"].int!
        isRead = json["isRead"].bool!
        receiverEmail = json["receiverEmail"].string
        lastMessageDateString = json["lastMessageDate"].string
        lastMessage = json["lastMessage"].string
        receiverUserName = json["receiverUserName"].string!
        receiverUserId = json["receiverUserId"].int!
        owner = json["owner"].bool!
        
        if let lastMessageDateString = lastMessageDateString {
            //Convertir el string de fecha en un objeto de tipo Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
            lastMessageDate = dateFormatter.date(from: lastMessageDateString)
            
            if lastMessageDate == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
                lastMessageDate = dateFormatter.date(from: lastMessageDateString)
            }
        }
        
    }
    
    init(withDbObject dbObject : NSManagedObject) {
        receiverAvatar = dbObject.value(forKey: "receiverAvatar") as! String?
        chatGroupId = dbObject.value(forKey: "chatGroupId") as! Int
        isRead = dbObject.value(forKey: "isRead") as! Bool
        receiverEmail = dbObject.value(forKey: "receiverEmail") as! String?
        lastMessageDateString = dbObject.value(forKey: "lastMessageDateString") as! String?
        lastMessage = dbObject.value(forKey: "lastMessage") as! String?
        receiverUserName = dbObject.value(forKey: "receiverUserName") as! String
        receiverUserId = dbObject.value(forKey: "receiverUserId") as! Int
        owner = dbObject.value(forKey: "owner") as! Bool
        
        if let lastMessageDateString = lastMessageDateString {
            //Convertir el string de fecha en un objeto de tipo Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
            lastMessageDate = dateFormatter.date(from: lastMessageDateString)
            
            if lastMessageDate == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
                lastMessageDate = dateFormatter.date(from: lastMessageDateString)
            }
        }
    }
}

class MessageModel {
    var id : Int
    var message : String
    var owner : Bool
    var senderUserName : String?
    var senderAvatar : String?
    var messageSequence : Int
    var read : Bool
    var chatGroupId : Int
    var receiverName : String?
    var receiverAvatar : String?
    var senderDateString : String?
    var senderDate : Date?
    
    init(forResponse json : JSON) {
        
        id = json["message"]["id"].int!
        message = json["chatGroup"]["lastMessage"].string!
        owner = true
        messageSequence = 0
        read = json["chatGroup"]["isRead"].bool!
        chatGroupId = json["chatGroup"]["chatGroupId"].int!
        receiverName = json["chatGroup"]["receiverUserName"].string
        receiverAvatar = json["chatGroup"]["receiverAvatar"].string
        senderDateString = json["chatGroup"]["lastMessageDate"].string
        
        if let senderDateString = senderDateString {
            //Convertir el string de fecha en un objeto de tipo Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSSxxxxx"
            senderDate = dateFormatter.date(from: senderDateString)
            
            if senderDate == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
                senderDate = dateFormatter.date(from: senderDateString)
            }
        }
    }
    
    init(withJsonObject json : JSON) {
        
        id = json["id"].int!
        message = json["message"].string!
        owner = json["owner"].bool!
        senderUserName = json["senderUser"]["senderUserName"].string
        senderAvatar = json["senderUser"]["avatar"].string
        messageSequence = json["messageSequence"].int!
        read = json["read"].bool!
        chatGroupId = json["chatGroupId"].int!
        receiverName = json["receiverUser"]["fullName"].string
        receiverAvatar = json["receiverUser"]["avatar"].string
        senderDateString = json["senderDate"].string
        
        if let senderDateString = senderDateString {
            //Convertir el string de fecha en un objeto de tipo Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
            senderDate = dateFormatter.date(from: senderDateString)
            
            if senderDate == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
                senderDate = dateFormatter.date(from: senderDateString)
            }
        }
        
        
    }
    
    init(withDbObject dbObject : NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        message = dbObject.value(forKey: "message") as! String
        owner = dbObject.value(forKey: "owner") as! Bool
        senderUserName = dbObject.value(forKey: "senderUserName") as! String?
        senderAvatar = dbObject.value(forKey: "senderAvatar") as! String?
        messageSequence = dbObject.value(forKey: "messageSequence") as! Int
        read = dbObject.value(forKey: "read") as! Bool
        chatGroupId = dbObject.value(forKey: "chatGroupId") as! Int
        receiverName = dbObject.value(forKey: "receiverName") as! String?
        receiverAvatar = dbObject.value(forKey: "receiverAvatar") as! String?
        senderDateString = dbObject.value(forKey: "senderDateString") as! String?
        
        if let senderDateString = senderDateString {
            //Convertir el string de fecha en un objeto de tipo Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
            senderDate = dateFormatter.date(from: senderDateString)
        }
    }
}

class ContactModel {
    var email  : String?
    var fullName : String
    var avatar : String?
    var id : Int
    var rol : String?
    
    init(withJsonObject json : JSON) {
        email = json["email"].string
        fullName = json["fullName"].string!
        avatar = json["avatar"].string
        id = json["id"].int!
        rol = json["rol"].string
    }
}


