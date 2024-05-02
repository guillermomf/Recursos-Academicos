//
//  LoginModel.swift
//  Recursos Academicos
//
//  Created by Gil casimiro on 07/03/24.
//


import Foundation
import SwiftyJSON
import CoreData

/// Modelo correspondiente a los Token de acceso al sistema
class ModelToken: Decodable {
    var access_token : String
    var refresh_token : String
    var token_type : String?
    var expires_in : Int?
    var userName : String
    var email : String
    var fullName : String
    var rol : String
    var issued : String?
    var expires : String?
    
    /// Inicializador del modelo para token, registra el token en las preferencias del dispositivo
    ///
    /// - Parameters:
    ///   - tokenString: Token proporcionado por el servicio
    ///   - userName: Nombre del usuario
    ///   - email: Correo del usuario
    ///   - fullName: Nombre completo del usuario
    ///   - role: Rol del usuario
    init (tokenString : String,refreshToken : String, userName : String, email: String, fullName : String, role : String) {
        
        //Inicializar los valores principales de la variable
        self.access_token = tokenString
        self.email = email
        self.userName = userName
        self.fullName = fullName
        self.rol = role
        self.refresh_token = refreshToken
        
        //Registrar los datos en las preferencias del dispositivo
        UserDefaults.standard.set(tokenString, forKey: Settings.userTokenKey)
        UserDefaults.standard.set(email, forKey: Settings.userEmailKey)
        UserDefaults.standard.set(userName, forKey: Settings.userNameKey)
        UserDefaults.standard.set(fullName, forKey: Settings.userFullNameKey)
        UserDefaults.standard.set(role, forKey: Settings.userRoleKey)
        UserDefaults.standard.set(refreshToken, forKey: Settings.userRefreshKey)
    }
}

class ModelContentNode {
    var numericalMapping : Any?
    var nodeAccessTypeId : Int
    var depth : Int
    var totalContent : Any?
    var id : Int
    var name : String
    var systemId : Int
    var pathIndex  : Int
    var description : String?
    var urlImage : String?
    var bookId : Int
    var nodeType  : String?
    var parentId  : Int
    var system : String?
    var isPublic : Bool
    var book : String?
    var nodeTypeId : Int
    var active : Bool
    
    init(withJsonObject json : JSON) {
        
        id = json["id"].int!
        systemId = json["systemId"].int!
        bookId = json["bookId"].int ?? 0
        nodeAccessTypeId = json["nodeAccessTypeId"].int!
        numericalMapping = json["numericalmapping"].object
        depth = json["depth"].int!
        totalContent = json["totalContent"].object
        name = json["name"].string!
        pathIndex = json["pathindex"].int!
        description = json["description"].string
        urlImage = json["urlImage"].string
        nodeType = json["nodeType"].string
        parentId = json["parentId"].int!
        system = json["system"].string
        isPublic = json["public"].bool!
        book = json["book"].string
        nodeTypeId = json["nodeTypeId"].int!
        active = json["active"].bool!
    }
    
    init (withDbObject dbObject : NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        systemId = dbObject.value(forKey: "systemId") as! Int
        nodeTypeId = dbObject.value(forKey: "nodeTypeId") as! Int
        nodeAccessTypeId = dbObject.value(forKey: "nodeAccessTypeId") as! Int
        parentId = dbObject.value(forKey: "parentId") as! Int
        bookId = dbObject.value(forKey: "bookId") as! Int
        book = dbObject.value(forKey: "book") as! String?
        name = dbObject.value(forKey: "name") as! String
        description = dbObject.value(forKey: "nodeDescription") as! String?
        urlImage = dbObject.value(forKey: "urlImage") as! String?
        nodeType = dbObject.value(forKey: "nodeType") as! String?
        system = dbObject.value(forKey: "system") as! String?
        totalContent = dbObject.value(forKey: "totalContent")
        numericalMapping = dbObject.value(forKey: "numericalMapping")
        depth = dbObject.value(forKey: "depth") as! Int
        pathIndex = dbObject.value(forKey: "pathIndex") as! Int
        isPublic = dbObject.value(forKey: "isPublic") as! Bool
        active = dbObject.value(forKey: "active") as! Bool
    }
}

class ModelContentFile {
    var id : Int
    var name : String
    var contentResourceType : String?
    var formativeField : String?
    var isRecommended : Bool
    var contentTypeDesc : String?
    var fileTypeId : Int
    var description : String?
    var purpose : String?
    var contentTypeId : Int
    var purposeId : Int
    var trainingField : String?
    var area : String?
    var isPublic : Bool
    var visits : Int
    var registerDate : String
    var thumbnails : String?
    var fileTypeDesc : String?
    var active : Bool
    var urlContent : String?
    
    init(withJsonObject json : JSON) {
        
        id = json["id"].int!
        name = json["name"].string!
        contentResourceType = json["contentResourceType"].string
        formativeField = json["formativeField"].string
        isRecommended = json["isRecommended"].bool!
        contentTypeDesc = json["contentTypeDesc"].string
        fileTypeId = json["fileTypeId"].int!
        description = json["description"].string
        purpose = json["purpose"]["description"].string
        contentTypeId = json["contentTypeId"].int!
        purposeId = json["purposeId"].int ?? 0
        trainingField = json["trainingField"].string
        area = json["area"].string
        isPublic = json["isPublic"].bool!
        visits = json["visits"].int!
        registerDate = json["registerDate"].string!
        thumbnails = json["thumbnails"].string
        fileTypeDesc = json["fileTypeDesc"].string
        active = json["active"].bool!
        urlContent = json["urlContent"].string
    }
    
    init (withDbObject dbObject : NSManagedObject) {
        id = dbObject.value(forKey: "id") as! Int
        name = dbObject.value(forKey: "name") as! String
        contentResourceType = dbObject.value(forKey: "contentResourceType") as! String?
        formativeField = dbObject.value(forKey: "formativeField") as! String?
        isRecommended = dbObject.value(forKey: "isRecommended") as! Bool
        contentTypeDesc = dbObject.value(forKey: "contentTypeDesc") as! String?
        fileTypeId = dbObject.value(forKey: "fileTypeId") as! Int
        description = dbObject.value(forKey: "fileDescription") as! String?
        purpose = dbObject.value(forKey: "purpose") as! String?
        contentTypeId = dbObject.value(forKey: "contentTypeId") as! Int
        purposeId = dbObject.value(forKey: "purposeId") as! Int
        trainingField = dbObject.value(forKey: "trainingField") as! String?
        area = dbObject.value(forKey: "area") as! String?
        isPublic = dbObject.value(forKey: "isPublic") as! Bool
        visits = dbObject.value(forKey: "visits") as! Int
        registerDate = dbObject.value(forKey: "registerDate") as! String
        thumbnails = dbObject.value(forKey: "thumbnails") as! String?
        fileTypeDesc = dbObject.value(forKey: "fileTypeDesc") as! String?
        active = dbObject.value(forKey: "active") as! Bool
        urlContent = dbObject.value(forKey: "urlContent") as! String?
    }
}

