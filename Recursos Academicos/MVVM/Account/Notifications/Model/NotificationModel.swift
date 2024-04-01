//
//  NotificationModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 12/03/24.
//

import Foundation
import SwiftyJSON

class NotificationModel {
    var id : Int
    var notificationTypeId : Int
    var userId : Int
    var title : String
    var message : String
    var registerDateString : String?
    var registerDate : Date?
    var readDateString : String?
    var readDate : Date?
    var read : Bool
    
    init(withJsonObject json: JSON){
        
        id = json["id"].int!
        notificationTypeId = json["id"].int!
        userId = json["id"].int!
        title = json["title"].string!
        message = json["message"].string!
        registerDateString = json["registerDate"].string
        readDateString = json["readDate"].string
        read = json["read"].bool!
        
        
        if let registerDateString = registerDateString {
            //Convertir el string de fecha en un objeto de tipo Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
            registerDate = dateFormatter.date(from: registerDateString)
            
            if registerDate == nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
                registerDate = dateFormatter.date(from: registerDateString)
            }
        }
        
        if readDateString != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss.SSS"
            readDate = dateFormatter.date(from: readDateString!)
        }
    }
}

class ListPagination {
    var maxPageSize : Int
    var showPreviousPage : Bool
    var pageSize : Int
    var total : Int
    var totalPage : Int
    var pageNumber : Int
    var showNextPage : Bool
    
    init(withJsonObject json: JSON) {
        maxPageSize =  json["mazPageSize"].int!
        showNextPage = json["showNextPage"].bool!
        showPreviousPage =  json["showPreviousPage"].bool!
        pageSize = json["pageSize"].int!
        totalPage = json["totalPage"].int!
        total = json["total"].int!
        pageNumber = json["pageNumber"].int!
    }
}
