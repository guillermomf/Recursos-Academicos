//
//  CoursesModel.swift
//  Recursos Academicos
//
//  Created by Daniel Cab Hernández on 25/02/19.
//  Copyright © 2019 Integra IT Soluciones. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class CoursesModel {
    var id : Int
    var name : String
    var description : String
    var goal : String
    var startDate : String
    var formattedStartDate : Date
    var endDate : String
    var formattedEndDate : Date
    var active : Bool
    var subject : String
    var nodeId : Int
    var node : String?
    var userId : Int
    var user : String?
    var registerDate : String?
    var updateDate : String?
    var monday : Bool
    var tuesday : Bool
    var wednesday : Bool
    var thursday : Bool
    var friday : Bool
    var saturday : Bool
    var sunday : Bool
    var professorName : String?
    var courseSections : [SectionModel]?
    var examSchedules : [CourseExamSchedule]?
    var groupId : Int
    
    /// Inicializar el modelo utilizando un objeto de tipo JSON
    ///
    /// - Parameter jsonObject: JSON que contiene el modelo
    init(jsonObject: JSON){
        self.id = jsonObject["id"].int!
        self.name = jsonObject["name"].string!
        self.description = jsonObject["description"].string!
        self.goal = jsonObject["gol"].string!
        self.startDate = jsonObject["startDate"].string!
        self.endDate = jsonObject["endDate"].string!
        self.active = jsonObject["active"].bool!
        self.subject = jsonObject["subject"].string!
        self.nodeId = jsonObject["nodeId"].int!
        self.node = jsonObject["node"].string
        self.userId = jsonObject["userId"].int!
        self.user = jsonObject["user"].string
        self.registerDate = jsonObject["registerDate"].string
        self.updateDate = jsonObject["updateDate"].string
        self.monday = jsonObject["monday"].bool!
        self.tuesday = jsonObject["tuesday"].bool!
        self.wednesday = jsonObject["wednesday"].bool!
        self.thursday = jsonObject["thursday"].bool!
        self.friday = jsonObject["friday"].bool!
        self.saturday = jsonObject["saturday"].bool!
        self.sunday = jsonObject["sunday"].bool!
        self.professorName = jsonObject["user"]["fullName"].string
        self.groupId = jsonObject["studentGroups"][0]["id"].int!
        
        //Convertir el string de fecha de inicio en un objeto de tipo Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
        self.formattedStartDate = dateFormatter.date(from: self.startDate)!
        
        //Convertir el string de fecha de fin en un objeto de tipo Date
        self.formattedEndDate = dateFormatter.date(from: self.endDate)!
        
        //Obtener el listado de programación de examenes
        examSchedules = []
        
        //Obtener el listado de secciones
        courseSections = []
        
        if let sections = jsonObject["courseSections"].array {
            for section in sections {
                let newSection = SectionModel(withJsonObject: section, coursedId: id)
                courseSections?.append(newSection)
            }
        }
        
    }
    
    /// Inicializar el modelo utilizando un objeto de BD
    ///
    /// - Parameter dbObject: Objeto de BD que contiene el modelo de contenido
    init(dbObject : NSManagedObject) {
        self.id = dbObject.value(forKey: "id") as! Int
        self.name = dbObject.value(forKey: "name") as! String
        self.description = dbObject.value(forKey: "courseDescription") as! String
        self.goal = dbObject.value(forKey: "goal") as! String
        self.startDate = dbObject.value(forKey: "startDate") as! String
        self.endDate = dbObject.value(forKey: "endDate") as! String
        self.active = dbObject.value(forKey: "active") as! Bool
        self.subject = dbObject.value(forKey: "subject") as! String
        self.nodeId = dbObject.value(forKey: "nodeId") as! Int
        self.node = dbObject.value(forKey: "node") as! String?
        self.userId = dbObject.value(forKey: "userId") as! Int
        self.user = dbObject.value(forKey: "user") as! String?
        self.registerDate = dbObject.value(forKey: "registerDate") as! String?
        self.updateDate = dbObject.value(forKey: "updateDate") as! String?
        self.monday = dbObject.value(forKey: "monday") as! Bool
        self.tuesday = dbObject.value(forKey: "tuesday") as! Bool
        self.wednesday = dbObject.value(forKey: "wednesday") as! Bool
        self.thursday = dbObject.value(forKey: "thursday") as! Bool
        self.friday = dbObject.value(forKey: "friday") as! Bool
        self.saturday = dbObject.value(forKey: "saturday") as! Bool
        self.sunday = dbObject.value(forKey: "sunday") as! Bool
        self.professorName = dbObject.value(forKey: "professorName") as! String?
        self.groupId = dbObject.value(forKey: "groupId") as! Int
        self.examSchedules = []
        
        //Convertir el string de fecha de inicio en un objeto de tipo Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd'T'HH:mm:ss"
        self.formattedStartDate = dateFormatter.date(from: self.startDate)!
        
        //Convertir el string de fecha de fin en un objeto de tipo Date
        self.formattedEndDate = dateFormatter.date(from: self.endDate)!
    }
}

class CoursePlanning{
    var id : Int
    var studentGroupId : Int
    var assistance : Int
    var homework : Int
    var activity : Int
    var exam : Int
    var partialQuantity : Int
    
    /// Inicializar el modelo utilizando un objeto de tipo JSON
    ///
    /// - Parameter jsonObject: JSON que contiene el modelo
    init(jsonObject: JSON){
        id = jsonObject["id"].int!
        studentGroupId = jsonObject["studentGroupId"].int!
        assistance = jsonObject["assistance"].int ?? 0
        homework = jsonObject["homework"].int ?? 0
        activity = jsonObject["activity"].int ?? 0
        exam = jsonObject["exam"].int ?? 0
        partialQuantity = jsonObject["numberPartial"].int ?? 00
    }
    
    init(dbObject: NSManagedObject){
        id = dbObject.value(forKey: "id") as! Int
        studentGroupId = dbObject.value(forKey: "studentGroupId") as! Int
        assistance = dbObject.value(forKey: "assistance") as! Int
        homework = dbObject.value(forKey: "homework") as! Int
        activity = dbObject.value(forKey: "activity") as! Int
        exam = dbObject.value(forKey: "exam") as! Int
        partialQuantity = dbObject.value(forKey: "partialQuantity") as! Int
    }
}

class CoursePartial {
    var id : Int
    var endDate : Date?
    var endDateString : String?
    var startDate : Date?
    var startDateString : String?
    var coursePlanningId : Int
    var description : String
    
    /// Inicializar el modelo utilizando un objeto de tipo JSON
    ///
    /// - Parameter jsonObject: JSON que contiene el modelo
    init(jsonObject: JSON){
        id = jsonObject["id"].int!
        coursePlanningId = jsonObject["coursePlanningId"].int ?? 0
        description = jsonObject["description"].string ?? "Parcial"
        endDateString = jsonObject["endDate"].string
        startDateString = jsonObject["startDate"].string
        
        if description.lowercased() == "final" {
            description = "Extra"
        }
        
        //Convertir el string de fecha en un objeto de tipo Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let startDateString = startDateString {
            startDate = dateFormatter.date(from: startDateString)
        }
        
        if let endDateString = endDateString {
            endDate = dateFormatter.date(from: endDateString)
        }
    }
    
    init(dbObject: NSManagedObject){
        id = dbObject.value(forKey: "id") as! Int
        coursePlanningId = dbObject.value(forKey: "coursePlanningId") as! Int
        description = dbObject.value(forKey: "partialDescription") as! String
        endDateString = dbObject.value(forKey: "endDateString") as! String?
        startDateString = dbObject.value(forKey: "startDateString") as! String?
        endDate = dbObject.value(forKey: "endDate") as! Date?
        startDate = dbObject.value(forKey: "startDate") as! Date?
    }
}
